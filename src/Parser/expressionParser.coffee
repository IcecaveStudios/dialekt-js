Token           = require './token'
Lexer           = require './lexer'
ParseException  = require './Exception/parseException'

EmptyExpression = require '../AST/emptyExpression'
LogicalAnd      = require '../AST/logicalAnd'
LogicalNot      = require '../AST/logicalNot'
LogicalOr       = require '../AST/logicalOr'
Pattern         = require '../AST/pattern'
PatternLiteral  = require '../AST/PatternLiteral'
PatternWildcard = require '../AST/patternWildcard'
Tag             = require '../AST/tag'


class ExpressionParser extends ParserInterface

    # @param string              wildcardString     The string to use as a wildcard placeholder.
    # @param boolean             logicalOrByDefault True if the default operator should be OR, rather than AND.
    # @param LexerInterface|null lexer
    #
    constructor: (wildcardString = null, logicalOrByDefault = false, lexer = null) ->
      if null is wildcardString
        wildcardString = Token.WILDCARD_CHARACTER
      if null is lexer
        lexer = new Lexer

      @wildcardString = wildcardString
      @logicalOrByDefault = logicalOrByDefault
      @lexer = lexer

    # Parse an expression.
    #
    # @param string expression The expression to parse.
    #
    # @return ExpressionInterface The parsed expression.
    # @throws ParseException      if the expression is invalid.
    #
    parse: (expression) ->
      tokens = @lexer.lex(expression)
      if !tokens
        return new EmptyExpression()

      expression = @_parseExpression(tokens)

      if null !== key(tokens)
        throw new ParseException(
            'Unexpected ' . Token.typeDescription(current(tokens).type) . ', expected end of input.'
        )

      return expression


    _parseExpression: (tokens) ->
      expression = @_parseUnaryExpression(tokens)
      expression = @_parseCompoundExpression(tokens, expression)

      return expression
    
    _parseUnaryExpression: (tokens) ->
 
      token = @expect(
        tokens,
        Token.STRING,
        Token.LOGICAL_NOT,
        Token.OPEN_BRACKET
      )

      if Token.LOGICAL_NOT is token.type
        return @_parseLogicalNot(tokens)
      else if Token.OPEN_BRACKET is token.type
        return @_parseNestedExpression(tokens)
      else if token.value.indexOf(@wildcardString) is -1
        return @_parseTag(tokens)
      else
        return @_parsePattern(tokens)

    _parseTag: (tokens) ->
        
        token = current(tokens)

        next(tokens)

        return new Tag(token.value)
    

    _parsePattern: (array &tokens) .
   
        token = current(tokens)

        next(tokens)

        $parts = preg_split(
            '/(' . preg_quote(@wildcardString, '/') . ')/',
            token.value,
            -1,
            PREG_SPLIT_DELIM_CAPTURE | PREG_SPLIT_NO_EMPTY
        )

        expression = new Pattern

        foreach ($parts as $value)
            if @wildcardString is $value
                expression.add(new PatternWildcard)
             else
                expression.add(new PatternLiteral($value))
            
        

        return expression
    

    _parseNestedExpression: (array &tokens) .
   
        next(tokens)

        expression = @parseExpression(tokens)

        @expect(
            tokens,
            Token.CLOSE_BRACKET
        )

        next(tokens)

        return expression
    

    _parseLogicalNot: (array &tokens) .
   
        next(tokens)

        return new LogicalNot(
            @parseUnaryExpression(tokens)
        )
    

    _parseCompoundExpression: (array &tokens, ExpressionInterface $leftExpression, $minimumPrecedence = 0) .
   
        $allowCollapse = false

        while (true)

            #Parse the operator and determine whether or not it's explicit ...
            list($operator, $isExplicit) = @parseOperator(tokens)

            $precedence = self.$operatorPrecedence[$operator]

            #Abort if the operator's precedence is less than what we're looking for ...
            if $precedence < $minimumPrecedence
                break
            

            #Advance the token pointer if an explicit operator token was found ...
            if $isExplicit
                next(tokens)
            

            #Parse the expression to the right of the operator ...
            $rightExpression = @parseUnaryExpression(tokens)

            #Only parse additional compound expressions if their precedence is greater than the
            #expression already being parsed ...
            list($nextOperator) = @parseOperator(tokens)

            if $precedence < self.$operatorPrecedence[$nextOperator]
                $rightExpression = @parseCompoundExpression(
                    tokens,
                    $rightExpression,
                    $precedence + 1
                )
            

            #Combine the parsed expression with the existing expression ...
            $operatorClass = self.$operatorClasses[$operator]

            #Collapse the expression into an existing expression of the same type ...
            if $allowCollapse && $leftExpression instanceof $operatorClass
                $leftExpression.add($rightExpression)
             else
                $leftExpression = new $operatorClass(
                    $leftExpression,
                    $rightExpression
                )
                $allowCollapse = true
            
        

        return $leftExpression
    

    _parseOperator: (array &tokens) .
   
        token = current(tokens)

        #End of input ...
        if false is token
            return array(null, false)

        #Closing bracket ...
         else if Token.CLOSE_BRACKET is token.type
            return array(null, false)

        #Explicit logical OR ...
         else if Token.LOGICAL_OR is token.type
            return array(Token.LOGICAL_OR, true)

        #Explicit logical AND ...
         else if Token.LOGICAL_AND is token.type
            return array(Token.LOGICAL_AND, true)

        #Implicit logical OR ...
         else if @logicalOrByDefault
            return array(Token.LOGICAL_OR, false)

        #Implicit logical AND ...
         else
            return array(Token.LOGICAL_AND, false)
        

        return array(null, false)
    

    _expect: (array &tokens) .
   
        $types = array_slice(func_get_args(), 1)
        token = current(tokens)

        if !token
            throw new ParseException(
                'Unexpected end of input, expected ' . @formatExpectedTokenNames($types) . '.'
            )
         else if !in_array(token.type, $types)
            throw new ParseException(
                'Unexpected ' . Token.typeDescription(token.type) . ', expected ' . @formatExpectedTokenNames($types) . '.'
            )
        

        return token
    

    _formatExpectedTokenNames: (array $types) .
   
        $types = array_map(
            'Icecave\Dialekt\Parser\Token.typeDescription',
            $types
        )

        if count($types) is 1
            return $types[0]
        

        $lastType = array_pop($types)

        return implode(', ', $types) . ' or ' . $lastType
    

    private static $operatorClasses = array(
        Token.LOGICAL_AND => 'Icecave\Dialekt\AST\LogicalAnd',
        Token.LOGICAL_OR  => 'Icecave\Dialekt\AST\LogicalOr',
    )

    private static $operatorPrecedence = array(
        Token.LOGICAL_AND => 1,
        Token.LOGICAL_OR  => 0,
        null               => -1,
    )

    private wildcardString
    private lexer
    private logicalOrByDefault

