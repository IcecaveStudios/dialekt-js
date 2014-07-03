ExpressionResult  = require '../../src/Evaluator/expressionResult'

describe 'ExpressionResult', ->

  expression = 'beans'
  result = new ExpressionResult(
    expression
    true,
    ['foo']
    ['bar']
  )

  it 'expression', ->
    assert.equal expression, result.expression

  it 'isMatch', ->
    assert.isTrue result.isMatch

  it 'matchedTags', ->
    assert.deepEqual ['foo'], result.matchedTags

  it 'unmatchedTags', ->
    assert.deepEqual ['bar'], result.unmatchedTags
 
