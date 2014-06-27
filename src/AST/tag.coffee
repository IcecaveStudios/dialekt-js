AbstractExpression = require './abstractExpression'
#
# An AST node that represents the logical NOT operator.
#
class Tag extends AbstractExpression

  #
  # @param string The tag name.
  #
  constructor: (name) ->
    @name = name

  # Pass this node to the appropriate method on the given visitor.
  #
  # @param VisitorInterface visitor The visitor to dispatch to.
  # @return mixed The visitation result.
  #
  accept: (visitor) ->
    visitor.visitTag(@)


module.exports = Tag
