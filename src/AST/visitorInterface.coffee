InterfaceException = require '../Exception/interfaceException'
#
# Interface for node visitors.
#
class VisitorInterface
 
  visitLogicalAnd: (logicalAndNode) ->
    throw new InterfaceException

  visitLogicalOr: (logicalOrNode) ->
    throw new InterfaceException

  visitLogicalNot: (logicalNotNode) ->
    throw new InterfaceException

  visitTag: (tagNode) ->
    throw new InterfaceException

  visitPattern: (PatternNode) ->
    throw new InterfaceException

  visitPatternLiteral: (PatternLiteralNode) ->
    throw new InterfaceException

  visitPatternWildcard: (PatternWildcard) ->
    throw new InterfaceException

  visitEmptyExpression: (emptyExpressionNode) ->
    throw new InterfaceException


module.exports = VisitorInterface
