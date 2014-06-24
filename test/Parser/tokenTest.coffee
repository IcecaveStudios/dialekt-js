Token = require '../../src/Parser/token'

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

describe "TokenTest", ->

  it 'Contructor', ->
    token = new Token Token.STRING, 'foo'
    chai.assert.equal Token.STRING, token.type
    chai.assert.equal 'foo', token.value
    
  describe 'Type Description', ->
    it 'Correct Types', ->
      tokenDescriptionsTestVectors.forEach (tokenTestVector) ->
        chai.assert.equal tokenTestVector.description, Token.typeDescription(tokenTestVector.type)
    it 'Incorrect Type', ->
      chai.expect(-> Token.typeDescription('unknown')).to.throw('Dialekt Token: Unknown type.')
      
