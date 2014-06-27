Tag = require '../../src/AST/tag'
LogicalOr = require '../../src/AST/logicalOr'
VisitorInterface = require '../../src/AST/visitorInterface'

#
# @covers AbstractPolyadicExpression
#
describe 'LogicalOr', ->
  # setup
  child1 = new Tag 'a'
  child2 = new Tag 'b'
  child3 = new Tag 'c'
  expression = new LogicalOr child1, child2

  it 'children', ->
    assert.deepEqual [child1, child2], expression.children

  it 'add', ->
    expression.add child3
    assert.deepEqual [child1, child2, child3], expression.children

  it 'accept', ->
    visitor = new VisitorInterface()
    mock = sinon.mock visitor
    mock.expects('visitLogicalOr')
    expression.accept visitor
    mock.verify()
    
  
    


