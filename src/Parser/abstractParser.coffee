ParserInterface = require './parserInterface'
Token           = require './token'
Lexer           = require './lexer'

EmptyExpression = require '../AST/emptyExpression'

InterfaceException  = require '../Exception/interfaceException'
ParseException      = require '../Exception/parseException'

class AbstractParser extends ParserInterface

  constructor: () -> 
    @tokenStack = []
    @setWildcardString(Token.WILDCARD_CHARACTER)

  # Set the string to use as a wildcard placeholder.
  #
  # @param {string} wildcardString The string to use as a wildcard placeholder.
  #
  setWildcardString: (wildcardString) ->
    @wildcardString = wildcardString

  # Parse an expression.
  #
  # @param {string}         expression The expression to parse.
  # @param {LexerInterface} lexer      The lexer to use to tokenise the string, or @return {Token} to use the default.
  #
  # @return {ExpressionInterface} The parsed expression.
  # @throw {ParseException}      if the expression is invalid.
  #
  parse: (expression, lexer) ->
    lexer ?= new Lexer

    return @parseTokens lexer.lex(expression)

  # Parse an expression that has already beed tokenized.
  #
  # @param [Array<Token>] The array of tokens that form the expression.
  #
  # @return {ExpressionInterface} The parsed expression.
  # @throw {ParseException}      if the expression is invalid.
  parseTokens: (tokens) ->
    # This acts as our array iterator
    @currentTokenIndex = 0
    @tokens = tokens

    if not @tokens or @tokens.length is 0
      return new EmptyExpression

    expression = @_parseExpression()

    if @tokens[@currentTokenIndex]
      throw new ParseException 'Unexpected ' + Token.typeDescription(@tokens[@currentTokenIndex].type) + ', expected end of input.'

    return expression

  _parseExpression: () ->
    throw new InterfaceException

  _expectToken: (args...) ->
    types = args
    token = @tokens[@currentTokenIndex]

    if not token 
      throw new ParseException 'Unexpected end of input, expected ' + @_formatExpectedTokenNames(types) + '.'
    else if token.type not in types
      throw new ParseException 'Unexpected ' + Token.typeDescription(token.type) + ', expected ' + @_formatExpectedTokenNames(types) + '.'

    return token

  _formatExpectedTokenNames: (types) ->
    types = types.map Token.typeDescription

    if types.length is 1
        return types[0]

    lastType = types.pop()

    return types.join(', ') +  ' or ' + lastType

  # Record the start of an expression.
  _startExpression: () ->
    @tokenStack.push @tokens[@currentTokenIndex]

  # Record the end of an expression.
  #
  # @param {ExpressionInterface} expression
  #
  # @return {ExpressionInterface}
  #
  _endExpression: (expression) ->
    #Find the end offset of the source for this node ...
    index = @currentTokenIndex

    # We're at the end of the input stream, so get the last token in
    # the token stream ...
    if @currentTokenIndex >= @tokens.length
      index = @tokens.length

    # The *current* token is the start of the next node, so we need to
    # look at the *previous* token to find the last token of this
    # expression ...
    expression.setTokens @tokenStack.pop(), @tokens[index-1]

    return expression


module.exports = AbstractParser
