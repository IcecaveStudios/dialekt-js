PatternLiteral = require '../../src/AST/PatternLiteral'
VisitorInterface = require '../../src/AST/visitorInterface'

describe "PatternLiteral", ->
  # setup
  patternLiteral = new PatternLiteral('foo')

  it 'string', ->
    chai.assert 'foo', patternLiteral.string

  it 'accept', ->
    visitor = new VisitorInterface()
    mock = sinon.mock visitor
    mock.expects('visitPatternLiteral')
    patternLiteral.accept visitor
    mock.verify()
    
    
