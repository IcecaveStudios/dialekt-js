Tag = require '../../src/AST/tag'
LogicalNot = require '../../src/AST/logicalNot'
VisitorInterface = require '../../src/AST/visitorInterface'

#
# @covers AbstractPolyadicOperator
#
describe 'LogicalNot', ->
  # setup
  child = new Tag 'a'
  expression = new LogicalNot child

  it 'child', ->
    chai.assert.deepEqual child, expression.child

  it 'accept', ->
    visitor = new VisitorInterface()
    mock = sinon.mock visitor
    mock.expects('visitLogicalNot')
    expression.accept visitor
    mock.verify()
    
  
    
