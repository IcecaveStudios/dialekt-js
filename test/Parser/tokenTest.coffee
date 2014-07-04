Token = require '../../src/Parser/token'
LogicException = require '../../src/Exception/logicException'

tokenDescriptionsTestVectors = [
  {
      type: Token.LOGICAL_AND
      description: 'AND operator'
  }
  {
      type: Token.LOGICAL_OR
      description: 'OR operator'
  }
  {
      type: Token.LOGICAL_NOT
      description: 'NOT operator'
  }
  {
      type: Token.STRING
      description: 'tag'
  }
  {
      type: Token.OPEN_BRACKET
      description: 'open bracket'
  }
  {
      type: Token.CLOSE_BRACKET
      description: 'close bracket'
 }
]

describe 'Token', ->

  it 'Constructor', ->
    token = new Token Token.STRING, 'foo', 1,2,3,4
    assert.equal Token.STRING, token.type
    assert.equal 'foo', token.value
    assert.equal 1, token.startOffset
    assert.equal 2, token.endOffset
    assert.equal 3, token.lineNumber
    assert.equal 4, token.columnNumber
    
  describe 'Type Description', ->
    describe 'correct types', ->
      tokenDescriptionsTestVectors.forEach (tokenTestVector) ->
        it tokenTestVector.description, ->
          assert.equal tokenTestVector.description, Token.typeDescription(tokenTestVector.type)
    it 'Incorrect Type', ->
      assert.throw (-> Token.typeDescription('unknown')), LogicException, 'Unknown type.'
      
