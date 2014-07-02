ExpressionRenderer = require '../../src/Renderer/expressionRenderer'

EmptyExpression  = require '../../src/AST/emptyExpression'
Pattern          = require '../../src/AST/pattern'
PatternLiteral   = require '../../src/AST/patternLiteral'
PatternWildcard  = require '../../src/AST/patternWildcard'
Tag              = require '../../src/AST/tag'
LogicalAnd       = require '../../src/AST/logicalAnd'
LogicalNot       = require '../../src/AST/logicalNot'
LogicalOr        = require '../../src/AST/logicalOr'

RenderException  = require '../../src/Exception/renderException'

renderTestVectors = 
  'empty expression':
    expression: new EmptyExpression
    result: 'NOT *'
  'tag':
    expression: new Tag('foo')
    result: 'foo'
  'escaped tag':
    expression: new Tag('f\\o"o')
    result: '"f\\\\o\\"o"'
  'escaped tag - logical and':
    expression: new Tag('and')
    result: '"and"'
  'escaped tag - logical or':
    expression: new Tag('or')
    result: '"or"'
  'escaped tag - logical not':
    expression: new Tag('not')
    result: '"not"'
  'tag with spaces':
    expression: new Tag('foo bar')
    result: '"foo bar"'
  'pattern':
    expression: new Pattern(
      new PatternLiteral('foo'),
      new PatternWildcard
    )
    result: 'foo*'
  'escaped pattern':
    expression: new Pattern(
      new PatternLiteral('foo"'),
      new PatternWildcard
    ),
    result: '"foo\\"*"'
  'logical and':
    expression: new LogicalAnd(
      new Tag('a'),
      new Tag('b'),
      new Tag('c')
    )
    result: '(a AND b AND c)'
  'logical or':
    expression: new LogicalOr(
      new Tag('a'),
      new Tag('b'),
      new Tag('c')
    )
    result: '(a OR b OR c)'
  'logical not':
    expression: new LogicalNot(
      new Tag('a')
    )
    result: 'NOT a'



describe 'Renderer', ->

  renderer = new ExpressionRenderer

  describe 'Render', ->
    for description, test of renderTestVectors then do (description, test) ->
      it description, ->
        chai.assert.deepEqual renderer.render(test.expression), test.result, description

    
  describe 'Render Failure', ->
    it 'wildcard in PatternLiteral', ->
      assert.throw -> 
        renderer.render new Pattern(new PatternLiteral('foo*'))
      , RenderException, 'The pattern literal "foo*" contains the wildcard string "*".'

