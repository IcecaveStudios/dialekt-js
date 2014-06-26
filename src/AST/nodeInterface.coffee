#
# An AST node.
#
class NodeInterface
  accept: (visitorInterface) ->
    throw Error("cannot call interface method")


module.exports = NodeInterface
