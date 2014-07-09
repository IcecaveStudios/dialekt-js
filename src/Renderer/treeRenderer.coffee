VisitorInterface = require '../AST/visitorInterface'
#
# Render an AST expression to a string representing the tree structure.
#
class TreeRenderer extends VisitorInterface

  # Construct a new tree renderer,
  #
  # @param {String}
  #
  # @return {Token} endOfLine The end-of-line string to use.
  #
  constructor: (endOfLine) ->
    @endOfLine = endOfLine or '\n'
  
  # Render an expression to a string.
  #
  # @param {ExpressionInterface} expression The expression to render.
  #
  # @return {String} The rendered expression.
  #
  render: (expression) ->
    return expression.accept @
  
  # Visit a LogicalAnd node.
  #
  # @param {LogicalAnd} node The node to visit.
  #
  # @return {mixed}
  #
  visitLogicalAnd: (node) ->
    return 'AND' + @endOfLine + @_renderChildren(node)

  # Visit a LogicalOr node.
  #
  # @param {LogicalOr} node The node to visit.
  #
  # @return {mixed}
  #
  visitLogicalOr: (node) ->
    return 'OR' + @endOfLine + @_renderChildren(node)
  
  # Visit a LogicalNot node.
  #
  # @param {LogicalNot} node The node to visit.
  #
  # @return {mixed}
  #
  visitLogicalNot: (node) ->
    child = node.child.accept @
    return 'NOT' + @endOfLine + @_indent('- ' + child)

  # Visit a Tag node.
  #
  # @param {Tag} node The node to visit.
  #
  # @return {mixed}
  #
  visitTag: (node) ->
    return 'TAG ' + JSON.stringify node.name

  # Visit a Pattern node.
  #
  # @param {Pattern} node The node to visit.
  #
  # @return {mixed}
  #
  visitPattern: (node) ->
    return 'PATTERN' + @endOfLine + @_renderChildren(node)
  
  # Visit a PatternLiteral node.
  #
  # @param {PatternLiteral} node The node to visit.
  #
  # @return {mixed}
  #
  visitPatternLiteral: (node) ->
    return 'LITERAL ' + JSON.stringify node.string
  
  # Visit a PatternWildcard node.
  #
  # @param {PatternWildcard} node The node to visit.
  #
  # @return {mixed}
  #
  visitPatternWildcard: (node) ->
    return 'WILDCARD'
  
  # Visit a EmptyExpression node.
  #
  # @param {EmptyExpression} node The node to visit.
  #
  # @return {mixed}
  #
  visitEmptyExpression: (node) ->
    return 'EMPTY'
  
  
  _renderChildren: (node) ->
    output = ''

    for n in node.children
      output += @_indent('- ' + n.accept(@)) + @endOfLine

    #rtrim
    return output.replace(/((\s*\S+)*)\s*/, "$1")

  _indent: (string) ->
    return '  ' + string.replace(@endOfLine, '$&' + '  ')
  

module.exports = TreeRenderer
