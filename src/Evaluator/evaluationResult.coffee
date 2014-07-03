#
# The overall result of the evaluation of an expression.
#
class EvaluationResult    
  # @param boolean                 isMatch           True if the expression matched the tag set otherwise, false.
  # @param array<ExpressionResult> expressionResults The individual sub-expression results.
  #
  constructor: (isMatch, expressionResults) ->
    @isMatch = isMatch
    @expressionResults = {}
    debugger
    for result in expressionResults
      @expressionResults[JSON.stringify(result.expression)] = result
    
  # Indicates whether or not the expression matched the tag set.
  #
  # @return boolean True if the expression matched the tag set otherwise, false.
  #
  isMatch: () ->
    return @isMatch
  
  # Fetch the result for an individual expression node from the AST.
  #
  # @param ExpressionInterface expression The expression for which the result is fetched.
  #
  # @return ExpressionResult         The result for the given expression.
  # @throws UnexpectedValueException if there is no result for the given expression.
  #
  resultOf: (expression) ->
    result = @expressionResults[JSON.stringify(expression)]
    if not result?
      throw new Error("Expression doesn't exist.")
    return result

  

module.exports = EvaluationResult

