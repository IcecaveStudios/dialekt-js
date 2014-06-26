ExpressionInterface = require './expressionInterface'
#
# A base class providing common functionality for polyadic operators: LogicalOr, LogicalAnd
#
class AbstractPolyadicOperator extends ExpressionInterface

  #
  # @param ExpressionInterface expressions[],... One or more children to add to this operator.
  #
  constructor: (expressions...) ->
    @children = expressions

  #
  # @param ExpressionInterface $expression The expression to add.
  # 
  add: (expression) ->
    @children.push expression


module.exports = AbstractPolyadicOperator

