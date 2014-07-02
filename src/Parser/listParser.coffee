AbstractParser  = require './abstractParser'
Token = require './token'

EmptyExpression = require '../AST/emptyExpression'
LogicalAnd      = require '../AST/logicalAnd'
Tag             = require '../AST/tag'

ParseException = require '../Exception/parseException'

# Parses a list of tags.
#
# The expression must be a space-separated list of tags. The result is
# either EmptyExpression, a single Tag node, or a LogicalAnd node
# containing only Tag nodes.
#
class ListParser extends AbstractParser

  _parseExpression: () ->
    @_startExpression()

    expression = null

    while (@tokens[@currentTokenIndex]) 

      token = @_expectToken(Token.STRING)

      if token.value.indexOf(@wildcardString) > -1 
        throw new ParseException(
          'Unexpected wildcard string "' + @wildcardString + '", in tag "' + token.value + '".'
        )

      @_startExpression()

      @currentTokenIndex++

      tag = new Tag(token.value)

      @_endExpression(tag)

      if (expression) 
        if (expression instanceof Tag) 
          expression = new LogicalAnd(expression) 
        expression.add(tag)
      else 
          expression = tag

    return @_endExpression(expression)
  

  # Parse a list of tags into an array.
  #
  # The expression must be a space-separated list of tags. The result is
  # an array of strings.
  #
  # @param string expression The tag list to parse.
  #
  # @return array<string>  The tags in the list.
  # @throws ParseException if the tag list is invalid.
  #
  parseAsArray: (expression) ->
    result = @parse(expression)

    if (result instanceof EmptyExpression) 
      return []
    else if (result instanceof Tag) 
      return [result.name]
    
    tags = []

    for node in result.children
      tags.push node.name

    return tags
  

module.exports = ListParser
