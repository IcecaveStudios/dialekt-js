LogicException = require '../Exception/logicException'

class Token
  # We want the constants associated with the constructor/class
  # So we can access them rubyish i.e Token.WILDCARD_CHARACTER
  @WILDCARD_CHARACTER : '*'
  @LOGICAL_AND        : 1
  @LOGICAL_OR         : 2
  @LOGICAL_NOT        : 3
  @STRING             : 4
  @OPEN_BRACKET       : 6
  @CLOSE_BRACKET      : 7

  constructor: (type, value, startOffset, endOffset, lineNumber, columnNumber) ->
    @type = type
    @value = value
    @startOffset = startOffset
    @endOffset = endOffset
    @lineNumber = lineNumber
    @columnNumber = columnNumber

  # static function, again we want it associated to the constructor/class
  @typeDescription: (type) ->
    switch type
      when Token.LOGICAL_AND
        return 'AND operator'
      when Token.LOGICAL_OR
        return 'OR operator'
      when Token.LOGICAL_NOT
        return 'NOT operator'
      when Token.STRING
        return 'tag'
      when Token.OPEN_BRACKET
        return 'open bracket'
      when Token.CLOSE_BRACKET
        return 'close bracket'
        
    throw new LogicException("Unknown type.")


module.exports = Token

