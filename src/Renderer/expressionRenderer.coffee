VisitorInterface = require '../AST/visitorInterface'
Token            = require '../Parser/token'
RenderException   = require '../Exception/renderException'

#
# Renders an AST expression to an expression string.
#
class ExpressionRenderer extends VisitorInterface
  #
  # @param string wildcardString The string to use as a wildcard placeholder.
  #
  constructor: (wildcardString) ->
    @wildcardString = wildcardString or Token.WILDCARD_CHARACTER
  
  # Render an expression to a string.
  #
  # @param ExpressionInterface expression The expression to render.
  #
  # @return string The rendered expression.
  #
  render: (expression) ->
    return expression.accept @
  
  # Visit a LogicalAnd node.
  #
  # @internal
  #
  # @param LogicalAnd node The node to visit.
  #
  # @return mixed
  #
  visitLogicalAnd: (node) ->
    expressions = []
    for n in node.children 
      expressions.push n.accept @
    
    return '(' + expressions.join(' AND ') + ')'
  
  # Visit a LogicalOr node.
  #
  # @internal
  #
  # @param LogicalOr node The node to visit.
  #
  # @return mixed
  #
  visitLogicalOr: (node) ->
    expressions = []
    for n in node.children 
      expressions.push n.accept @
    
    return '(' + expressions.join(' OR ') + ')'
  
  # Visit a LogicalNot node.
  #
  # @internal
  #
  # @param LogicalNot node The node to visit.
  #
  # @return mixed
  #
  visitLogicalNot: (node) ->
    return 'NOT ' + node.child.accept @
  
  # Visit a Tag node.
  #
  # @internal
  #
  # @param Tag node The node to visit.
  #
  # @return mixed
  #
  visitTag: (node) ->
    return ExpressionRenderer.escapeString node.name

  # Visit a Pattern node.
  #
  # @internal
  #
  # @param Pattern node The node to visit.
  #
  # @return mixed
  #
  visitPattern: (node) ->
    string = ''

    for n in node.children
      string += n.accept @    

    return ExpressionRenderer.escapeString string
  
  # Visit a PatternLiteral node.
  #
  # @internal
  #
  # @param PatternLiteral node The node to visit.
  #
  # @return mixed
  #
  visitPatternLiteral: (node) ->  
    if node.string.indexOf(@wildcardString) is -1 
      return node.string
    
    throw new RenderException(
      'The pattern literal "' + node.string + '" contains the wildcard string "' + @wildcardString + '".'
    )
  
  # Visit a PatternWildcard node.
  #
  # @internal
  #
  # @param PatternWildcard node The node to visit.
  #
  # @return mixed
  #
  visitPatternWildcard: (node) ->
    return @wildcardString
  
  # Visit a EmptyExpression node.
  #
  # @internal
  #
  # @param EmptyExpression node The node to visit.
  #
  # @return mixed
  #
  visitEmptyExpression: (node) ->
    return 'NOT ' + @wildcardString
  
  @escapeString: (string) ->  
    if string.toUpperCase() in ['AND', 'OR', 'NOT']
      return '"' + string + '"';

    replacedStr = string.replace(/[\(\)"\\\\]/g, '\\$&')

    if (replacedStr isnt string) or string.match(/\s/)
      return '"' + replacedStr + '"'
    
    return string;
  

module.exports = ExpressionRenderer
