ExpressionInterface = require './expressionInterface'
#
# A base class providing common functionality for expressions.
#
class AbstractExpression extends ExpressionInterface

  # Fetch the first token from the source that is part of this expression.
  #
  # @return Token|null The first token from this expression.
  #
  firstToken: () ->
    return @_firstToken

  # Fetch the last token from the source that is part of this expression.
  #
  # @return Token|null The last token from this expression.
  #
  lastToken: () ->
    return @_lastToken

  # Set the delimiting tokens for this expression.
  #
  # @param Token $firstToken The first token from this expression.
  # @param Token $lastToken  The last token from this expression.
  #
  setTokens: (firstToken, lastToken) ->
    @_firstToken = firstToken
    @_lastToken = lastToken


module.exports = AbstractExpression
