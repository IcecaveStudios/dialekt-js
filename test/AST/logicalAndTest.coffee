Tag = require '../../src/AST/tag'
LogicalAnd = require '../../src/AST/logicalAnd'
VisitorInterface = require '../../src/AST/visitorInterface'

#
# @covers AbstractPolyadicOperator
#
describe 'LogicalAnd', ->
  # setup
  child1 = new Tag 'a'
  child2 = new Tag 'b'
  child3 = new Tag 'c'
  expression = new LogicalAnd child1, child2

  it 'children', ->
    chai.assert.deepEqual [child1, child2], expression.children

  it 'add', ->
    expression.add child3
    chai.assert.deepEqual [child1, child2, child3], expression.children

  it 'accept', ->
    visitor = new VisitorInterface()
    mock = sinon.mock visitor
    mock.expects('visitLogicalAnd')
    expression.accept visitor
    mock.verify()
    
  
    


