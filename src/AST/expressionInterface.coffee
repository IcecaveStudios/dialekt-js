NodeInterface = require './nodeInterface'
InterfaceException = require '../Exception/interfaceException'
#
# An AST node that is an expression.
#
# Not all nodes in the tree represent an entire (sub-)expression.
#
class ExpressionInterface extends NodeInterface

  # Fetch the first token from the source that is part of this expression.
  #
  # @return {Token} The first token from this expression.
  #
  firstToken: () ->
    throw new InterfaceException()

  # Fetch the last token from the source that is part of this expression.
  #
  # @return {Token} The last token from this expression.
  #
  lastToken: () ->
    throw new InterfaceException()

  # Set the delimiting tokens for this expression.
  #
  # @param {Token} firstToken The first token from this expression.
  # @param {Token} lastToken  The last token from this expression.
  #
  setTokens: (firstToken, lastToken) ->
    throw new InterfaceException()

    
module.exports = ExpressionInterface
