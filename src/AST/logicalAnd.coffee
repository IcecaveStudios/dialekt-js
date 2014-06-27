AbstractPolyadicExpression = require './AbstractPolyadicExpression'
#
# An AST node that represents the logical AND operator.
#
class LogicalAnd extends AbstractPolyadicExpression
  
  # Pass this node to the appropriate method on the given visitor.
  #
  # @param VisitorInterface visitor The visitor to dispatch to.
  # @return mixed The visitation result.
  #
  accept: (visitor) ->
    return visitor.visitLogicalAnd(@)


module.exports = LogicalAnd
