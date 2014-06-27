AbstractExpression = require '../../src/AST/abstractExpression'
LogicException = require '../../src/Exception/logicException'

describe 'AbstractExpression', ->

  node = new AbstractExpression()
    
  it 'no source', ->
    assert.throw (-> node.source()), LogicException, 'Source has not been captured.'

  it 'no offset', ->
    assert.throw (-> node.sourceOffset()), LogicException, 'Source offset has not been captured.'    
  
  it 'set source', ->
    node.setSource 'foobar', 12
    assert.equal 'foobar', node._source
    assert.equal 12, node._sourceOffset

  it 'has source', ->
    assert.isTrue node.hasSource()

    
