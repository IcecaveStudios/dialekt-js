#
# Interface for node visitors.
#
class VisitorInterface
 
  visitLogicalAnd: (logicalAndNode) ->
    throw new Error("cannot call interface method")

  visitLogicalOr: (logicalOrNode) ->
    throw new Error("cannot call interface method")

  visitLogicalNot: (logicalNotNode) ->
    throw new Error("cannot call interface method")

  visitTag: (tagNode) ->
    throw new Error("cannot call interface method")

  visitPattern: (PatternNode) ->
    throw new Error("cannot call interface method")

  visitPatternLiteral: (PatternLiteralNode) ->
    throw new Error("cannot call interface method")

  visitPatternWildcard: (PatternWildcard) ->
    throw new Error("cannot call interface method")

  visitEmptyExpression: (emptyExpressionNode) ->
    throw new Error("cannot call interface method")


module.exports = VisitorInterface
