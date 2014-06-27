NodeInterface = require './nodeInterface'
InterfaceException = require '../Exception/interfaceException'
#
# An AST node that is an expression.
#
# Not all nodes in the tree represent an entire (sub-)expression.
#
class ExpressionInterface extends NodeInterface

  # Fetch the original source code of this expression.
  #
  # @return string         The original source code of this expression.
  # @throws LogicException if the source has not been captured by the parser.
  #
  source: ->
    throw new InterfaceException()

  # Fetch the index of the first character of this expression in the source code.
  #
  # @return integer        The index of the first character of this expression in the source code.
  # @throws LogicException if the source has not been captured by the parser.
  #
  sourceOffset: ->
    throw new InterfaceException()

  # Indiciates whether or not the expression contains information about the
  # original source of the expression.
  #
  # @return boolean True if the source/offset has been captured; otherwise, false.
  #
  hasSource: ->
    throw new InterfaceException()

    
module.exports = ExpressionInterface
