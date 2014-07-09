Token = require './token'
ParseException = require '../Exception/parseException'

class Lexer

  @STATE_BEGIN:                1
  @STATE_SIMPLE_STRING:        2
  @STATE_QUOTED_STRING:        3
  @STATE_QUOTED_STRING_ESCAPE: 4

  # Tokenize an expression.
  #
  # @param {string} expression The expression to tokenize.
  #
  # @return [Array<Token>]   The tokens of the expression.
  # @throw {ParseException} if the expression is invalid.
  #
  lex: (expression) ->

    # EOL = '\n'
    # newLineLength = EOL.length

    @currentOffset = 0
    @currentLine   = 1
    @currentColumn = 0
    @state = Lexer.STATE_BEGIN #this.constructor.STATE_BEGIN
    @tokens = []
    @buffer = ''

    previousChar = null

    expLength = expression.length
    while @currentOffset < expLength

      char = expression.charAt(@currentOffset)
      @currentColumn++
      
      if '\n' is previousChar or ('\r' is previousChar and '\n' isnt char)
        @currentLine++
        @currentColumn = 1

      if Lexer.STATE_SIMPLE_STRING is @state
        @_handleSimpleStringState char
      else if Lexer.STATE_QUOTED_STRING is @state
        @_handleQuotedStringState char
      else if Lexer.STATE_QUOTED_STRING_ESCAPE is @state
        @_handleQuotedStringEscapeState char
      else
        @_handleBeginState char

      @currentOffset++
      previousChar = char
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
      @_startToken Token.OPEN_BRACKET
      @_endToken char
    else if char is ')'
      @_startToken Token.CLOSE_BRACKET
      @_endToken char
    else if char is '"'
      @_startToken Token.STRING
      @state = Lexer.STATE_QUOTED_STRING
    else
      @_startToken Token.STRING
      @state = Lexer.STATE_SIMPLE_STRING
      @buffer = char
    
  _handleSimpleStringState: (char) ->
    if Lexer.ctype_space(char)
      @_finalizeSimpleString()
    else if char is '(' 
      @_finalizeSimpleString()
      @_startToken Token.OPEN_BRACKET
      @_endToken char
    else if char is ')' 
      @_finalizeSimpleString()
      @_startToken Token.CLOSE_BRACKET
      @_endToken char
    else
       @buffer += char

  _handleQuotedStringState: (char) ->
    if char is '\\'
      @state = Lexer.STATE_QUOTED_STRING_ESCAPE
    else if char is '"'
      @_endToken @buffer
      @state = Lexer.STATE_BEGIN
      @buffer = ''
    else
      @buffer += char

  _handleQuotedStringEscapeState: (char) ->
    @state = Lexer.STATE_QUOTED_STRING
    @buffer += char

  _finalizeSimpleString: ->
    if Lexer.strcasecmp('and', @buffer)
      @nextToken.type = Token.LOGICAL_AND
    else if Lexer.strcasecmp('or', @buffer)
      @nextToken.type = Token.LOGICAL_OR
    else if Lexer.strcasecmp('not', @buffer)
      @nextToken.type = Token.LOGICAL_NOT

    @_endToken @buffer, -1
    @state = Lexer.SdTATE_BEGIN
    @buffer = ''

  _startToken: (type) ->
    @nextToken = new Token(
      type,
      '',
      @currentOffset,
      0,
      @currentLine,
      @currentColumn
    )

  _endToken: (value, lengthAdjustment = 0) ->
    @nextToken.value = value
    @nextToken.endOffset = @currentOffset + lengthAdjustment + 1
    @tokens.push @nextToken
    @nextToken = null

  # checks if string is all white space
  @ctype_space: (str) ->
    return str.trim() is ''

  # case insensitive compare
  @strcasecmp: (str1, str2) ->
    return String(str1).toUpperCase() is String(str2).toUpperCase()
    
module.exports = Lexer
