Token = require './token'
ParseException = require './Exception/parseException'

class Lexer

  @STATE_BEGIN:                1
  @STATE_SIMPLE_STRING:        2
  @STATE_QUOTED_STRING:        3
  @STATE_QUOTED_STRING_ESCAPE: 4


  ##
  ## Tokenize an expression.
  ##
  ## @param string 'expression' The expression to parse.
  ##
  ## @return array<Token>   The tokens of the expression.
  ## @throws ParseException if the expression is invalid.
  ##
  lex: (expression) ->

    @state = Lexer.STATE_BEGIN #this.constructor.STATE_BEGIN
    @tokens = []
    @buffer = ''
    
    chars = expression?.split('') or [] #protects against expression == undefined
    
    for char in chars
      if Lexer.STATE_SIMPLE_STRING is @state
        @_handleSimpleStringState char
      else if Lexer.STATE_QUOTED_STRING is @state
        @_handleQuotedStringState char
      else if Lexer.STATE_QUOTED_STRING_ESCAPE is @state
        @_handleQuotedStringEscapeState char
      else
        @_handleBeginState char

    if Lexer.STATE_SIMPLE_STRING is @state
      @_finalizeSimpleString()
    else if Lexer.STATE_QUOTED_STRING is @state
      throw new ParseException 'Expected closing quote.'
    else if Lexer.STATE_QUOTED_STRING_ESCAPE is @state
      throw new ParseException 'Expected character after backslash.'

    return @tokens

  # Private Functions

  _handleBeginState: (char) ->
    if Lexer.ctype_space(char)
        # ignore
    else if char is '('
      @tokens.push new Token(Token.OPEN_BRACKET, char)
    else if char is ')'
      @tokens.push new Token(Token.CLOSE_BRACKET, char)
    else if char is '"'
      @state = Lexer.STATE_QUOTED_STRING;
    else
      @state = Lexer.STATE_SIMPLE_STRING;
      @buffer = char;
    

  _handleSimpleStringState: (char) ->
    if Lexer.ctype_space(char)
       @_finalizeSimpleString();
    else if char is '(' 
       @_finalizeSimpleString();
       @tokens.push new Token(Token.OPEN_BRACKET, char)
    else if char is ')' 
       @_finalizeSimpleString();
       @tokens.push new Token(Token.CLOSE_BRACKET, char)
    else
       @buffer += char;

  _handleQuotedStringState: (char) ->
    if char is '\\'
      @state = Lexer.STATE_QUOTED_STRING_ESCAPE;
    else if char is '"'
      @tokens.push new Token(Token.STRING, @buffer);
      @state = Lexer.STATE_BEGIN;
      @buffer = '';
    else
      @buffer += char;

  _handleQuotedStringEscapeState: (char) ->
    @state = Lexer.STATE_QUOTED_STRING;
    @buffer += char;

  _finalizeSimpleString: ->
    if Lexer.strcasecmp('and', @buffer)
      tokenType = Token.LOGICAL_AND
    else if Lexer.strcasecmp('or', @buffer)
      tokenType = Token.LOGICAL_OR
    else if Lexer.strcasecmp('not', @buffer)
      tokenType = Token.LOGICAL_NOT
    else
      tokenType = Token.STRING

    @tokens.push new Token(tokenType, @buffer)
    @state = Lexer.STATE_BEGIN;
    @buffer = '';

  # checks if string is all white space
  @ctype_space: (str) ->
    return str.trim() is ''

  # case insensitive compare
  @strcasecmp: (str1, str2) ->
    return String(str1).toUpperCase() is String(str2).toUpperCase()
    
module.exports = Lexer
