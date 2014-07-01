AbstractParser  = require './abstractParser'
Token           = require './token'
Lexer           = require './lexer'

ParseException  = require '../Exception/parseException'

EmptyExpression = require '../AST/emptyExpression'
LogicalAnd      = require '../AST/logicalAnd'
LogicalNot      = require '../AST/logicalNot'
LogicalOr       = require '../AST/logicalOr'
Pattern         = require '../AST/pattern'
PatternLiteral  = require '../AST/PatternLiteral'
PatternWildcard = require '../AST/patternWildcard'
Tag             = require '../AST/tag'


class ExpressionParser extends AbstractParser
  #
  # @param LexerInterface|null lexer The lexer used to tokenise input expressions.
  #
  constructor: (lexer) ->
    super lexer
    @setLogicalOrByDefault(false);
  
  #
  # Indicates whether or not the the default operator should be OR, rather
  # than AND.
  #
  # @param boolean logicalOrByDefault True if the default operator should be OR, rather than AND.
  #
  setLogicalOrByDefault: (logicalOrByDefault) ->
    @logicalOrByDefault = logicalOrByDefault
  
  _parseExpression: () ->
    @_startExpression()

    expression = @_parseUnaryExpression()
    expression = @_parseCompoundExpression(expression)

    return @_endExpression(expression)
  
  _parseUnaryExpression: () ->

    token = @_expectToken(
        Token.STRING,
        Token.LOGICAL_NOT,
        Token.OPEN_BRACKET
    )

    if Token.LOGICAL_NOT is token.type
      return @_parseLogicalNot();
     else if Token.OPEN_BRACKET is token.type
      return @_parseNestedExpression()
     else if token.value.indexOf(@wildcardString) is -1 
        return @_parseTag()
     else 
        return @_parsePattern()

  _parseTag: () ->
    @_startExpression()
    
    expression = new Tag @tokens[@currentTokenIndex].value
    
    @currentTokenIndex++
    
    return @_endExpression(expression)
  
  _parsePattern: () ->
    @_startExpression()
    # http://stackoverflow.com/questions/3446170/escape-string-for-use-in-javascript-regex/6969486#6969486
    escapedWildcard = @wildcardString.replace(/[-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&")

    tokenValue = @tokens[@currentTokenIndex].value
    # we surround with () to make it capture the delimeter characters
    parts = tokenValue.split new RegExp('(' + escapedWildcard + ')')
    # remove '' empty strings
    parts = parts.filter(Boolean)
    expression = new Pattern

    for part in parts
      if @wildcardString is part
          expression.add new PatternWildcard
      else 
          expression.add new PatternLiteral(part) 
    
    @currentTokenIndex++

    return @_endExpression(expression)

  _parseNestedExpression: () ->
    @_startExpression()

    @currentTokenIndex++

    expression = @_parseExpression()
    
    @_expectToken(Token.CLOSE_BRACKET)
    
    @currentTokenIndex++

    return @_endExpression(expression)
  
  _parseLogicalNot: () ->
    @_startExpression()

    @currentTokenIndex++

    return @_endExpression new LogicalNot(@_parseUnaryExpression())
  
  _parseCompoundExpression: (leftExpression, minimumPrecedence = 0) ->
  
    allowCollapse = false

    while (true) 
      # Parse the operator and determine whether or not it's explicit ...
      [operator, isExplicit] = @_parseOperator()

      precedence = ExpressionParser.operatorPrecedence(operator)

      # Abort if the operator's precedence is less than what we're looking for ...
      if precedence < minimumPrecedence
        break

      # Advance the token pointer if an explicit operator token was found ...
      if isExplicit
        @currentTokenIndex++
      
      # Parse the expression to the right of the operator ...
      rightExpression = @_parseUnaryExpression()

      # Only parse additional compound expressions if their precedence is greater than the
      # expression already being parsed ...
      [nextOperator] = @_parseOperator()

      if precedence < ExpressionParser.operatorPrecedence(nextOperator) 
        rightExpression = @_parseCompoundExpression(
            rightExpression,
            precedence + 1
        )
      
      # Combine the parsed expression with the existing expression ...
      operatorClass = ExpressionParser.operatorClasses(operator)

      # Collapse the expression into an existing expression of the same type ...
      if allowCollapse and leftExpression instanceof operatorClass
        leftExpression.add(rightExpression)
      else 
        leftExpression = new operatorClass(
            leftExpression,
            rightExpression
        )
        allowCollapse = true;

    return leftExpression
  
  _parseOperator: () ->
    token = @tokens[@currentTokenIndex]

    if not token?
      return [null, false]

    # Closing bracket ...
    else if Token.CLOSE_BRACKET is token.type
        return [null, false]

    # Explicit logical OR ...
    else if Token.LOGICAL_OR is token.type
        return [Token.LOGICAL_OR, true]

    # Explicit logical AND ...
    else if Token.LOGICAL_AND is token.type
        return [Token.LOGICAL_AND, true]

    # Implicit logical OR ...
    else if @logicalOrByDefault
        return [Token.LOGICAL_OR, false]

    # Implicit logical AND ...
     else 
        return [Token.LOGICAL_AND, false]
    
    return [null, false]
  
  @operatorClasses = (operator) ->
    switch operator
      when Token.LOGICAL_AND
        return LogicalAnd
      when Token.LOGICAL_OR
        return LogicalOr
      else
        return null

  @operatorPrecedence = (operator) ->
    switch operator
      when Token.LOGICAL_AND
        return 1
      when Token.LOGICAL_OR
        return 0
      else
        return -1


module.exports = ExpressionParser

