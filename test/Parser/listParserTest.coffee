EmptyExpression = require '../../src/AST/emptyExpression'
LogicalAnd      = require '../../src/AST/logicalAnd'
Tag             = require '../../src/AST/tag'

ListParser      = require '../../src/Parser/listParser'
Lexer           = require '../../src/Parser/lexer'
Token           = require '../../src/Parser/token'

ParseException  = require '../../src/Exception/parseException'


parseTestVectors = 
  'empty expression':
    expression: ''
    result: new EmptyExpression
    resultTags: []

  'single tag':
    expression: 'foo'
    result: new Tag('foo')
    resultTags: ['foo']

  'multiple tags':
    expression: 'foo "bar spam"'
    result: new LogicalAnd(
        new Tag('foo'),
        new Tag('bar spam')
    )
    resultTags: ['foo', 'bar spam']


describe 'ListParser', ->

  parser = new ListParser

  it.skip 'Parse', ->
    #todo

  describe 'Parse as Array', ->
    for description, test of parseTestVectors then do (description, test) ->
      it description, ->
        # console.log description
        chai.assert.deepEqual parser.parseAsArray(test.expression), test.resultTags, description

  it 'Tokens', ->
    lexer = new Lexer
    tokens = lexer.lex('a b c')
    result = parser.parseTokens(tokens)

    assert.equal tokens[0], result.firstToken()
    assert.equal tokens[2], result.lastToken()

    children = result.children

    node = children[0]
    assert.equal tokens[0], node.firstToken()
    assert.equal tokens[0], node.lastToken()

    node = children[1]
    assert.equal tokens[1], node.firstToken()
    assert.equal tokens[1], node.lastToken()

    node = children[2]
    assert.equal tokens[2], node.firstToken()
    assert.equal tokens[2], node.lastToken()
    
  describe 'Parse Failure', ->
    it 'non string', ->
      assert.throw (-> parser.parse('and')), ParseException, 'Unexpected AND operator, expected tag.'

    it 'with wildcard', ->
      assert.throw (-> parser.parse('foo*')), ParseException, 'Unexpected wildcard string "*", in tag "foo*".'
      
