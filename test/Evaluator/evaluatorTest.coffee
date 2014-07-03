Evaluator  = require '../../src/Evaluator/evaluator'

ExpressionResult  = require '../../src/Evaluator/expressionResult'
EvaluationResult  = require '../../src/Evaluator/evaluationResult'

EmptyExpression  = require '../../src/AST/emptyExpression'
Pattern          = require '../../src/AST/pattern'
PatternLiteral   = require '../../src/AST/patternLiteral'
PatternWildcard  = require '../../src/AST/patternWildcard'
Tag              = require '../../src/AST/tag'
LogicalAnd       = require '../../src/AST/logicalAnd'
LogicalNot       = require '../../src/AST/logicalNot'
LogicalOr        = require '../../src/AST/logicalOr'


# [expression, tags, expected]
evaluateTestVectors = [
  [
    new EmptyExpression,
    ['foo'],
    false,
  ]
  [
    new Tag('foo'),
    ['foo'],
    true,
  ]
  [
    new Tag('foo'),
    ['bar'],
    false,
  ]
  [
    new Tag('foo'),
    ['foo', 'bar'],
    true,
  ]
  [
    new Pattern(
        new PatternLiteral('foo'),
        new PatternWildcard
    ),
    ['foobar'],
    true,
  ]
  [
    new LogicalAnd(
        new Tag('foo'),
        new Tag('bar')
    ),
    ['foo'],
    false,
  ]
  [
    new LogicalAnd(
        new Tag('foo'),
        new Tag('bar')
    ),
    ['bar'],
    false,
  ]
  [
    new LogicalAnd(
        new Tag('foo'),
        new Tag('bar')
    ),
    ['foo', 'bar'],
    true,
  ]
  [
    new LogicalAnd(
        new Tag('foo'),
        new Tag('bar')
    ),
    ['foo', 'bar', 'spam'],
    true,
  ]
  [
    new LogicalAnd(
        new Tag('foo'),
        new Tag('bar')
    ),
    ['foo', 'spam'],
    false,
  ]
  [
    new LogicalOr(
        new Tag('foo'),
        new Tag('bar')
    ),
    ['foo'],
    true,
  ]
  [
    new LogicalOr(
        new Tag('foo'),
        new Tag('bar')
    ),
    ['bar'],
    true,
  ]
  [
    new LogicalOr(
        new Tag('foo'),
        new Tag('bar')
    ),
    ['foo', 'spam'],
    true,
  ]
  [
    new LogicalOr(
        new Tag('foo'),
        new Tag('bar')
    ),
    ['spam'],
    false,
  ]
  [
    new LogicalNot(
        new Tag('foo')
    ),
    ['foo'],
    false,
  ]
  [
    new LogicalNot(
        new Tag('foo')
    ),
    ['foo', 'bar'],
    false,
  ]
  [
    new LogicalNot(
        new Tag('foo')
    ),
    ['bar'],
    true,
  ]
  [
    new LogicalNot(
        new Tag('foo')
    ),
    ['bar', 'spam'],
    true,
  ]
  [
    new LogicalAnd(
        new Tag('foo'),
        new LogicalNot(
            new Tag('bar')
        )
    ),
    ['foo'],
    true,
  ]
  [
    new LogicalAnd(
        new Tag('foo'),
        new LogicalNot(
            new Tag('bar')
        )
    ),
    ['foo', 'spam'],
    true,
  ]
  [
    new LogicalAnd(
        new Tag('foo'),
        new LogicalNot(
            new Tag('bar')
        )
    ),
    ['foo', 'bar', 'spam'],
    false,
  ]
  [
    new LogicalAnd(
        new Tag('foo'),
        new LogicalNot(
            new Tag('bar')
        )
    ),
    ['spam'],
    false,
  ]
]

describe 'Evaluator', ->
  evaluator = new Evaluator

  it 'constructor', ->
    assert.isFalse evaluator.caseSensitive
    assert.isFalse evaluator.emptyIsWildcard

  describe 'evaluate', ->
    for test, i in evaluateTestVectors then do (test, i) ->
      [expression, tags, expected] = test
      it tags, ->
        result = evaluator.evaluate expression, tags
        assert.instanceOf result, EvaluationResult
        chai.assert.equal expected, result.isMatch

    it 'caseSensitive', ->
      evaluatorCS = new Evaluator(true)
      expression = new Tag('foo')

      assert.isTrue evaluatorCS.evaluate(expression, ['foo']).isMatch
      assert.isFalse evaluatorCS.evaluate(expression, ['FOO']).isMatch

    it 'PatternCaseSensitive', ->
      evaluatorCS = new Evaluator(true)
      expression = new Pattern(
          new PatternLiteral('foo'),
          new PatternWildcard
      )

      assert.isTrue evaluatorCS.evaluate(expression, ['foobar']).isMatch
      assert.isFalse evaluatorCS.evaluate(expression, ['FOOBAR']).isMatch

    it 'EmptyExpressionAsWildcard', ->
      evaluatorEAW = new Evaluator(false, true)
      assert.isTrue evaluatorEAW.evaluate(new EmptyExpression, ['foobar']).isMatch

    it 'EvaluateLogicalAnd', ->
      innerExpression1 = new Tag('foo')
      innerExpression2 = new Tag('bar')
      innerExpression3 = new Tag('bar')
      expression = new LogicalAnd(
          innerExpression1,
          innerExpression2,
          innerExpression3
      )
      result = evaluator.evaluate(
          expression,
          ['foo', 'bar', 'spam']
      )

      assert.instanceOf result, EvaluationResult
      assert.isTrue result.isMatch

      expressionResult = result.resultOf expression 
      assert.instanceOf expressionResult, ExpressionResult
      assert.isTrue expressionResult.isMatch
      assert.deepEqual ['foo', 'bar'], expressionResult.matchedTags
      assert.deepEqual ['spam'], expressionResult.unmatchedTags

      expressionResult = result.resultOf innerExpression1
      assert.instanceOf expressionResult, ExpressionResult
      assert.isTrue expressionResult.isMatch
      assert.deepEqual ['foo'], expressionResult.matchedTags
      assert.deepEqual ['bar', 'spam'], expressionResult.unmatchedTags

      expressionResult = result.resultOf innerExpression2
      assert.instanceOf expressionResult, ExpressionResult
      assert.isTrue expressionResult.isMatch
      assert.deepEqual ['bar'], expressionResult.matchedTags
      assert.deepEqual ['foo', 'spam'], expressionResult.unmatchedTags

      expressionResult = result.resultOf(innerExpression3)
      assert.instanceOf expressionResult, ExpressionResult
      assert.isTrue expressionResult.isMatch
      assert.deepEqual ['bar'], expressionResult.matchedTags
      assert.deepEqual ['foo', 'spam'], expressionResult.unmatchedTags
    
    it 'EvaluateLogicalOr', ->
    
      innerExpression1 = new Tag('foo')
      innerExpression2 = new Tag('bar')
      innerExpression3 = new Tag('doom')
      expression = new LogicalOr(
          innerExpression1,
          innerExpression2,
          innerExpression3
      )

      result = evaluator.evaluate(
          expression,
          ['foo', 'bar', 'spam']
      )

      assert.instanceOf result, EvaluationResult
      assert.isTrue result.isMatch

      expressionResult = result.resultOf(expression)
      assert.instanceOf expressionResult, ExpressionResult
      assert.isTrue expressionResult.isMatch
      assert.deepEqual ['foo', 'bar'], expressionResult.matchedTags
      assert.deepEqual ['spam'], expressionResult.unmatchedTags

      expressionResult = result.resultOf(innerExpression1)
      assert.instanceOf expressionResult, ExpressionResult
      assert.isTrue expressionResult.isMatch
      assert.deepEqual ['foo'], expressionResult.matchedTags
      assert.deepEqual ['bar', 'spam'], expressionResult.unmatchedTags

      expressionResult = result.resultOf(innerExpression2)
      assert.instanceOf expressionResult, ExpressionResult
      assert.isTrue expressionResult.isMatch
      assert.deepEqual ['bar'], expressionResult.matchedTags
      assert.deepEqual ['foo', 'spam'], expressionResult.unmatchedTags

      expressionResult = result.resultOf(innerExpression3)
      assert.instanceOf expressionResult, ExpressionResult
      assert.isFalse expressionResult.isMatch
      assert.deepEqual [], expressionResult.matchedTags
      assert.deepEqual ['foo', 'bar', 'spam'], expressionResult.unmatchedTags
    
    it 'EvaluateLogicalNot', ->
      innerExpression = new Tag('foo')
      expression = new LogicalNot(innerExpression)

      result = evaluator.evaluate(
          expression,
          ['foo', 'bar']
      )

      assert.instanceOf result, EvaluationResult
      assert.isFalse result.isMatch

      expressionResult = result.resultOf(expression)
      assert.instanceOf expressionResult, ExpressionResult
      assert.isFalse expressionResult.isMatch
      assert.deepEqual ['bar'], expressionResult.matchedTags
      assert.deepEqual ['foo'], expressionResult.unmatchedTags

      expressionResult = result.resultOf(innerExpression)
      assert.instanceOf expressionResult, ExpressionResult
      assert.isTrue expressionResult.isMatch
      assert.deepEqual ['foo'], expressionResult.matchedTags
      assert.deepEqual ['bar'], expressionResult.unmatchedTags
    
    it 'EvaluateTag', ->
    
      expression = new Tag('foo')

      result = evaluator.evaluate(
          expression,
          ['foo', 'bar']
      )

      assert.instanceOf result, EvaluationResult
      assert.isTrue result.isMatch

      expressionResult = result.resultOf(expression)
      assert.instanceOf expressionResult, ExpressionResult
      assert.isTrue expressionResult.isMatch
      assert.deepEqual ['foo'], expressionResult.matchedTags
      assert.deepEqual ['bar'], expressionResult.unmatchedTags
    
    it 'EvaluatePattern', ->
    
      expression = new Pattern(
          new PatternLiteral('foo'),
          new PatternWildcard
      )

      result = evaluator.evaluate(
          expression,
          ['foo1', 'foo2', 'bar']
      )

      assert.instanceOf result, EvaluationResult
      assert.isTrue result.isMatch

      expressionResult = result.resultOf(expression)
      assert.instanceOf expressionResult, ExpressionResult
      assert.isTrue expressionResult.isMatch
      assert.deepEqual ['foo1', 'foo2'], expressionResult.matchedTags
      assert.deepEqual ['bar'], expressionResult.unmatchedTags
    
    it 'EvaluateEmptyExpression', ->
    
      expression = new EmptyExpression

      result = evaluator.evaluate(
          expression,
          ['foo', 'bar']
      )

      assert.instanceOf result, EvaluationResult
      assert.isFalse result.isMatch

      expressionResult = result.resultOf(expression)
      assert.instanceOf expressionResult, ExpressionResult
      assert.isFalse expressionResult.isMatch
      assert.deepEqual [], expressionResult.matchedTags
      assert.deepEqual ['foo', 'bar'], expressionResult.unmatchedTags
    
