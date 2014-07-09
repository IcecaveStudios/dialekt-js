#
# The result for an invidiual expression in the AST.
#
class ExpressionResult
  # @param {ExpressionInterface}  expression    The expression to which this result applies.
  # @param {Boolean}              isMatch       True if the expression matched the tag set otherwise, false.
  # @param [Array<String>]        matchedTags   The set of tags that matched.
  # @param [Array<String>]        unmatchedTags The set of tags that did not match.
  #
  constructor: (expression, isMatch, matchedTags, unmatchedTags) ->
    @expression = expression
    @isMatch = isMatch
    @matchedTags = matchedTags
    @unmatchedTags = unmatchedTags
    
  
module.exports = ExpressionResult


  
