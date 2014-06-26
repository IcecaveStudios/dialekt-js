PatternWildcard = require '../../src/AST/patternWildcard'
VisitorInterface = require '../../src/AST/visitorInterface'

describe 'PatternWildcard', ->

  expression = new PatternWildcard()
  
  it 'accept', ->
    visitor = new VisitorInterface()
    mock = sinon.mock visitor
    mock.expects('visitPatternWildcard')
    expression.accept visitor
    mock.verify()
    
