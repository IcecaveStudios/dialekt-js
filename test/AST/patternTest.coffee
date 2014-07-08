Pattern = require '../../src/AST/pattern'
PatternLiteral = require '../../src/AST/patternLiteral'
PatternWildcard = require '../../src/AST/patternWildcard'
VisitorInterface = require '../../src/AST/visitorInterface'

#
# @covers AbstractPolyadicExpression
#
describe 'LogicalAnd', ->
  # setup
  child1 = new PatternLiteral 'foo'
  child2 = new PatternWildcard()
  child3 = new PatternLiteral 'bar'
  expression = new Pattern child1, child2

  it 'children', ->
    assert.deepEqual [child1, child2], expression.children

  it 'add', ->
    expression.add child3
    assert.deepEqual [child1, child2, child3], expression.children

  it 'accept', ->
    visitor = new VisitorInterface()
    mock = sinon.mock visitor
    mock.expects('visitPattern')
    expression.accept visitor
    mock.verify()
    
  
    


