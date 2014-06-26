ExpressionInterface = require './expressionInterface'
#
# An AST node that represents the logical NOT operator.
#
class LogicalNot extends ExpressionInterface

  #
  # @param ExpressionInterface expression, The expression being inverted by the NOT operator.
  #
  constructor: (expression) ->
    @child = expression
  
  # Pass this node to the appropriate method on the given visitor.
  #
  # @param VisitorInterface visitor, The visitor to dispatch to.
  # @return mixed The visitation result.
  #
  accept: (visitor) ->
    visitor.visitLogicalNot(@)


module.exports = LogicalNot



