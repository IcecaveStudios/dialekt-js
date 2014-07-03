ExpressionResult  = require '../../src/Evaluator/expressionResult'
EvaluationResult  = require '../../src/Evaluator/evaluationResult'


describe 'ExpressionResult', ->

  expression = 'beans'
  expressionResult = new ExpressionResult(
    expression
    true,
    ['foo']
    ['bar']
  )
  result = new EvaluationResult(
    true,
    [expressionResult]
  )

  it 'isMatch', ->
    assert.isTrue result.isMatch

  it 'resultOf', ->
    assert.deepEqual expressionResult, result.resultOf(expression)

  it 'result of with unknown expression', ->
    assert.throws ->
      result.resultOf('nonExistingExpression')
    , Error, "Expression doesn't exist."
 
