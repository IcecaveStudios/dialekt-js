AbstractExpression = require '../../src/AST/abstractExpression'
Token = require '../../src/Parser/token'

describe 'AbstractExpression', ->

  node = new AbstractExpression()
    
  it 'defaults', ->
    assert.isUndefined node.firstToken()
    assert.isUndefined node.lastToken()

  it 'setTokens', ->
    t1 = new Token
    t2 = new Token
    node.setTokens t1, t2
    assert.equal t1, node.firstToken()
    assert.equal t2, node.lastToken()


    
