VisitorInterface = require '../AST/visitorInterface'
ExpressionResult = require './expressionResult'
EvaluationResult = require './evaluationResult'

class Evaluator extends VisitorInterface
    
  # @param {Boolean} caseSensitive   True if tag matching should be case-sensitive otherwise, false.
  # @param {Boolean} emptyIsWildcard True if an empty expression matches all tags or false to match none.
  #
  constructor: (@caseSensitive, @emptyIsWildcard) ->
    @caseSensitive ?= false
    @emptyIsWildcard ?= false 

  # Evaluate an expression against a set of tags.
  #
  # @param {ExpressionInterface} expression The expression to evaluate.
  # @param [Mixed<string>]       tags       The set of tags to evaluate against.
  #
  # @return {EvaluationResult} The result of the evaluation.
  #
  evaluate: (expression, tags) ->
    @tags = tags
    @expressionResults = []

    result = new EvaluationResult(
        expression.accept(@).isMatch,
        @expressionResults
    )

    @tags = null
    @expressionResults = null

    return result

  # Visit a LogicalAnd node.
  #
  # @param {LogicalAnd} node The node to visit.
  #
  # @return {mixed}
  #
  visitLogicalAnd: (node) ->
    matchedTags = []
    isMatch = true
    for n in node.children
      result = n.accept @
      if not result.isMatch 
        isMatch = false

      # ignore duplicates
      for tag in result.matchedTags
        if -1 is matchedTags.indexOf(tag)
          matchedTags.push tag
    
    # diff 
    diff = []
    @tags.forEach (tag) ->
      if -1 is matchedTags.indexOf(tag)
        diff.push tag

    result = new ExpressionResult(
      node,
      isMatch,
      matchedTags,
      diff
    )
    @expressionResults.push result

    return result


  # Visit a LogicalOr node.
  #
  #
  # @param {LogicalOr} node The node to visit.
  #
  # @return {mixed}
  #
  visitLogicalOr: (node) ->
    matchedTags = []
    isMatch = false

    for n in node.children 
      result = n.accept @

      if result.isMatch
        isMatch = true
      
      # dedup
      for tag in result.matchedTags
        if -1 is matchedTags.indexOf(tag)
          matchedTags.push tag

    diff = []
    @tags.forEach (tag) ->
      if -1 is matchedTags.indexOf(tag)
        diff.push tag

    result = new ExpressionResult(
        node,
        isMatch,
        matchedTags,
        diff
    )
    @expressionResults.push result

    return result

  # Visit a LogicalNot node.
  #
  #
  # @param {LogicalNot} node The node to visit.
  #
  # @return {mixed}
  #
  visitLogicalNot: (node) ->
    childResult = node.child.accept @
    result = new ExpressionResult(
        node,
        not childResult.isMatch,
        childResult.unmatchedTags,
        childResult.matchedTags
    )
    @expressionResults.push result
    return result

  # Visit a Tag node.
  #
  #
  # @param {Tag} node The node to visit.
  #
  # @return {mixed}
  #
  visitTag: (node) ->
    if @caseSensitive 
      predicate = (tag) =>
        return node.name is tag
    else 
      predicate = (tag) => 
        return node.name.toUpperCase() is tag.toUpperCase()

    return @_matchTags(
        node,
        predicate
    )

  # Visit a pattern node.
  #
  #
  # @param {Pattern} node The node to visit.
  #
  # @return {mixed}
  #
  visitPattern: (node) ->

    pattern = '^'

    for n in node.children
      pattern += n.accept @
    
    pattern += '$'

    re = new RegExp pattern, if @caseSensitive then '' else 'i'

    return @_matchTags(
      node,
      (tag) ->  
        return tag.match(re)
    )

  # Visit a PatternLiteral node.
  #
  # @param {PatternLiteral} node The node to visit.
  #
  # @return {mixed}
  #
  visitPatternLiteral: (node) ->
    # preg_quote
    return node.string.replace(new RegExp('[.\\\\+*?\\[\\^\\]$(){}=!<>|:\\' + ('/' || '') + '-]', 'g'), '\\$&');


  # Visit a PatternWildcard node.
  #
  # @param {PatternWildcard} node The node to visit.
  #
  # @return {mixed}
  #
  visitPatternWildcard: (node) ->
    return '.*'



  # Visit a EmptyExpression node.
  #
  #
  # @param {EmptyExpression} node The node to visit.
  #
  # @return {mixed}
  #
  visitEmptyExpression: (node) ->
    result =  new ExpressionResult(
        node,
        @emptyIsWildcard,
        if @emptyIsWildcard then @tags else [],
        if @emptyIsWildcard then [] else @tags
    )
    @expressionResults.push result

    return result


  _matchTags: (expression, predicate) ->
    matchedTags = []
    unmatchedTags = []

    for tag in @tags
      if predicate(tag)
        matchedTags.push tag
       else 
        unmatchedTags.push tag


    result = new ExpressionResult(
        expression,
        matchedTags.length > 0,
        matchedTags,
        unmatchedTags
    )
    @expressionResults.push result

    return result


module.exports = Evaluator

