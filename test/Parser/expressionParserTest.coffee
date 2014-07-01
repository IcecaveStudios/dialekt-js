ExpressionParser = require '../../src/Parser/expressionParser'

EmptyExpression  = require '../../src/AST/emptyExpression'
Pattern          = require '../../src/AST/pattern'
PatternLiteral   = require '../../src/AST/patternLiteral'
PatternWildcard  = require '../../src/AST/patternWildcard'
Tag              = require '../../src/AST/tag'
LogicalAnd       = require '../../src/AST/logicalAnd'
LogicalNot       = require '../../src/AST/logicalNot'
LogicalOr        = require '../../src/AST/logicalOr'

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



describe 'ExpressionParser', ->

  describe 'Parse', ->
    for description, test of parseTestVectors then do (description, test) ->
      it description, ->
        parser = new ExpressionParser
        # console.log description
        # chai.assert.deepEqual parser.parse(test.expression), test.result, description
        chai.assert.equal JSON.stringify(parser.parse(test.expression)), JSON.stringify(test.result)

    # it 'single test', ->
    #   parser = new ExpressionParser
    #   test = parseTestVectors["logical or"]
    #   debugger
    #   result = parser.parse(test.expression)
    #   chai.assert.equal JSON.stringify(parser.parse(test.expression)), JSON.stringify(test.result)
    #   debugger
