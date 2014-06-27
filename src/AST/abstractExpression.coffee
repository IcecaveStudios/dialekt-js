ExpressionInterface = require './expressionInterface'
LogicException      = require '../Exception/logicException'
#
# A base class providing common functionality for expressions.
#
class AbstractExpression extends ExpressionInterface

  # Fetch the original source code of this expression.
  #
  # @return string The original source code of this expression.
  #
  source: ->
    if not @_source?
      throw new LogicException('Source has not been captured.')

    return @_source

  # Fetch the index of the first character of this expression in the source code.
  #
  # @return integer The index of the first character of this expression in the source code.
  #
  sourceOffset: () ->  
    if not @_sourceOffset?
      throw new LogicException('Source offset has not been captured.')

    return @_sourceOffset
  
  # Indiciates whether or not the expression contains information about the
  # original source of the expression.
  #
  # @return boolean True if the source/offset has been captured otherwise, false.
  #
  hasSource: ->
    return @_source?
  
  # Set the original source code of this expression.
  #
  # @param string  $source       The original source code of this expression.
  # @param integer $sourceOffset The offset into the original source code where this code begins.
  #
  setSource: (source, sourceOffset) ->
    @_source = source
    @_sourceOffset = sourceOffset

module.exports = AbstractExpression
