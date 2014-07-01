ExpressionParser = require '../../src/Parser/expressionParser'
Lexer            = require '../../src/Parser/lexer'

EmptyExpression  = require '../../src/AST/emptyExpression'
Pattern          = require '../../src/AST/pattern'
PatternLiteral   = require '../../src/AST/patternLiteral'
PatternWildcard  = require '../../src/AST/patternWildcard'
Tag              = require '../../src/AST/tag'
LogicalAnd       = require '../../src/AST/logicalAnd'
LogicalNot       = require '../../src/AST/logicalNot'
LogicalOr        = require '../../src/AST/logicalOr'

ParseException = require '../../src/Exception/parseException'

parseTestVectors = 
  'empty expression':
    expression: '',
    result: new EmptyExpression
  'single tag':
    expression: 'a'
    result: new Tag('a')
  'tag pattern':
    expression: 'a*'
    result: new Pattern(
      new PatternLiteral('a'),
      new PatternWildcard
    )
  'multiple tags':
    expression: 'a b c'
    result: new LogicalAnd(
      new Tag('a'),
      new Tag('b'),
      new Tag('c')
    )
  'multiple tags with nesting':
    expression: 'a (b c)'
    result: new LogicalAnd(
      new Tag('a'),
      new LogicalAnd(
          new Tag('b'),
          new Tag('c')
        )
      )
  'multiple nested groups remain nested':
    expression: '(a b) (c d)'
    result: new LogicalAnd(
      new LogicalAnd(
        new Tag('a'),
        new Tag('b')
        ),
      new LogicalAnd(
        new Tag('c'),
        new Tag('d')
      )
    )
  'logical and':
    expression: 'a AND b'
    result: new LogicalAnd(
      new Tag('a'),
      new Tag('b')
    )
  'logical and chained':
    expression: 'a AND b AND c'
    result: new LogicalAnd(
      new Tag('a'),
      new Tag('b'),
      new Tag('c')
    )
  'logical or':
    expression: 'a OR b'
    result: new LogicalOr(
      new Tag('a'),
      new Tag('b')
    )
  'logical or chained':
    expression: 'a OR b OR c'
    result: new LogicalOr(
      new Tag('a'),
      new Tag('b'),
      new Tag('c')
    )
  'logical not':
    expression: 'NOT a'
    result: new LogicalNot(
      new Tag('a')
    )
  'logical not chained':
    expression: 'NOT NOT a'
    result: new LogicalNot(
      new LogicalNot(
        new Tag('a')
      )
    )
  'logical operator implicit precedence 1':
    expression: 'a OR b AND c'
    result: new LogicalOr(
      new Tag('a'),
      new LogicalAnd(
        new Tag('b'),
        new Tag('c')
      )
    )
  'logical operator implicit precedence 2':
    expression: 'a AND b OR c'
    result: new LogicalOr(
      new LogicalAnd(
        new Tag('a'),
        new Tag('b')
      ),
      new Tag('c')
    )
  'logical operator explicit precedence 1':
    expression: '(a OR b) AND c'
    result: new LogicalAnd(
      new LogicalOr(
        new Tag('a'),
        new Tag('b')
      ),
      new Tag('c')
    )
  'logical operator explicit precedence 2':
    expression: 'a AND (b OR c)'
    result: new LogicalAnd(
      new Tag('a'),
      new LogicalOr(
        new Tag('b'),
        new Tag('c')
      )
    )
  'logical not implicit precedence':
    expression: 'NOT a AND b'
    result: new LogicalAnd(
      new LogicalNot(
        new Tag('a')
      ),
      new Tag('b')
    )
  'logical not explicit precedence':
    expression: 'NOT (a AND b)'
    result: new LogicalNot(
      new LogicalAnd(
        new Tag('a'),
        new Tag('b')
      )
    )
  'complex nested':
    expression: 'a ((b OR c) AND (d OR e)) f'
    result: new LogicalAnd(
      new Tag('a'),
      new LogicalAnd(
        new LogicalOr(
            new Tag('b'),
            new Tag('c')
            ),
          new LogicalOr(
            new Tag('d'),
            new Tag('e')
            )
        ),
      new Tag('f')
    )

parseFailureTestVectors = 
  'leading logical and':
    expression: 'AND a'
    result: 'Unexpected AND operator, expected tag, NOT operator or open bracket.',
  'leading logical or':
    expression: 'OR a'
    result: 'Unexpected OR operator, expected tag, NOT operator or open bracket.',
  'trailing logical and':
    expression: 'a AND'
    result: 'Unexpected end of input, expected tag, NOT operator or open bracket.',
  'trailing logical or':
    expression: 'a OR'
    result: 'Unexpected end of input, expected tag, NOT operator or open bracket.',
  'mismatched braces 1':
    expression: '(a'
    result: 'Unexpected end of input, expected close bracket.'
  'mismatched braces 2':
    expression: 'a)'
    result: 'Unexpected close bracket, expected end of input.'

describe 'ExpressionParser', ->
  parser = new ExpressionParser
  lexer = new Lexer

  describe 'Parse', ->

    # for description, test of parseTestVectors then do (description, test) ->
    #   it description, ->
    #     # console.log description
    #     # chai.assert.deepEqual parser.parse(test.expression), test.result, description
    #     assert.equal JSON.stringify(parser.parse(test.expression)), JSON.stringify(test.result)
        # for description, test of parseTestVectors then do (description, test) ->
    
    describe 'Fail tests', ->
      for description, test of parseFailureTestVectors then do (description, test) ->
        it description, ->
          debugger
          assert.throw (-> parser.parse(test.expression)), ParseException, test.result

    it 'using LogicalOrAsDefaultOperator', ->
      parserLOR = new ExpressionParser
      parserLOR.setLogicalOrByDefault true
      expression = '((a AND b) OR (c AND d))'

      result = parser.parse expression
      console.log "IMPLEMENT LOR DEFAULT"


    it 'with Source Capture', ->
      expression = 'a AND (b OR c) AND NOT p*'
      tokens = lexer.lex expression
      result = parser.parse expression

      assert.deepEqual tokens[0], result.firstToken()
      assert.deepEqual tokens[9], result.lastToken()

      children = result.children
      node = children[0]
      assert.deepEqual tokens[0], node.firstToken()
      assert.deepEqual tokens[0], node.lastToken()

      node = children[1]
      assert.deepEqual tokens[2], node.firstToken()
      assert.deepEqual tokens[6], node.lastToken()

      node = children[2]
      assert.deepEqual tokens[8], node.firstToken()
      assert.deepEqual tokens[9], node.lastToken()

      subNode = children[2].child
      assert.deepEqual tokens[9], subNode.firstToken()
      assert.deepEqual tokens[9], subNode.lastToken()

      nodeChildren = children[1].children
      subNode = nodeChildren[0]
      assert.deepEqual tokens[3], subNode.firstToken()
      assert.deepEqual tokens[3], subNode.lastToken()

      subNode = nodeChildren[1]
      assert.deepEqual tokens[5], subNode.firstToken()
      assert.deepEqual tokens[5], subNode.lastToken()



      

      # children = result.children

      # chai.assert.equal JSON.stringify(parser.parse(test.expression)), JSON.stringify(test.result)

    # it 'single test', ->
    #   parser = new ExpressionParser
    #   test = parseTestVectors["logical or"]
    #   debugger
    #   result = parser.parse(test.expression)
    #   chai.assert.equal JSON.stringify(parser.parse(test.expression)), JSON.stringify(test.result)
    #   debugger
