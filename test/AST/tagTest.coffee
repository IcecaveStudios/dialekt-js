Tag = require '../../src/AST/tag'
VisitorInterface = require '../../src/AST/visitorInterface'

describe "Tag", ->
  # setup
  tag = new Tag('foo')

  it 'name', ->
    chai.assert 'foo', tag.name

  it 'accept', ->
    visitor = new VisitorInterface()
    mock = sinon.mock visitor
    mock.expects('visitTag')
    tag.accept visitor
    mock.verify()
    
    
