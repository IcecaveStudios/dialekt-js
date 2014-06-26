EmptyExpression = require '../../src/AST/emptyExpression'
VisitorInterface = require '../../src/AST/visitorInterface'

describe 'EmptyExpression', ->

  it 'accept', ->
    expression = new EmptyExpression()
    visitor = new VisitorInterface()
    mock = sinon.mock visitor
    mock.expects('visitEmptyExpression')
    expression.accept visitor
    mock.verify()
    
