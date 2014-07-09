#
# The overall result of the evaluation of an expression.
#
class EvaluationResult    
  # @param {Boolean}                  isMatch           True if the expression matched the tag set otherwise, false.
  # @param [Array<ExpressionResult>]  expressionResults The individual sub-expression results.
  #
  constructor: (isMatch, expressionResults) ->
    @isMatch = isMatch
    @expressionResults = {}
    for result in expressionResults
      @expressionResults[JSON.stringify(result.expression)] = result
  
  # Fetch the result for an individual expression node from the AST.
  #
  # @param {ExpressionInterface} expression The expression for which the result is fetched.
  #
  # @return {ExpressionResult}         The result for the given expression.
  # @throw {UnexpectedValueException} if there is no result for the given expression.
  #
  resultOf: (expression) ->
    result = @expressionResults[JSON.stringify(expression)]
    if not result?
      throw new Error("Expression doesn't exist.")
    return result

  

module.exports = EvaluationResult

