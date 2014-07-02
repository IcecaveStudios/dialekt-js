TreeRenderer = require '../../src/Renderer/treeRenderer'

EmptyExpression  = require '../../src/AST/emptyExpression'
Pattern          = require '../../src/AST/pattern'
PatternLiteral   = require '../../src/AST/patternLiteral'
PatternWildcard  = require '../../src/AST/patternWildcard'
Tag              = require '../../src/AST/tag'
LogicalAnd       = require '../../src/AST/logicalAnd'
LogicalNot       = require '../../src/AST/logicalNot'
LogicalOr        = require '../../src/AST/logicalOr'

RenderException  = require '../../src/Exception/renderException'

renderTestVectors =   
  'empty expression':
    expression: new EmptyExpression
    result: 'EMPTY'
  'tag':
    expression: new Tag('foo')
    result: 'TAG "foo"'
  'escaped tag':
    expression: new Tag('f\\o"o')
    result: 'TAG "f\\\\o\\"o"'
  'escaped tag - logical and':
    expression: new Tag('and')
    result: 'TAG "and"'
  'escaped tag - logical or':
    expression: new Tag('or')
    result: 'TAG "or"'
  'escaped tag - logical not':
    expression: new Tag('not')
    result: 'TAG "not"'
  'tag with spaces':
    expression: new Tag('foo bar')
    result: 'TAG "foo bar"'
  'pattern':
    expression: new Pattern(
        new PatternLiteral('foo'),
        new PatternWildcard
    )
    result: 'PATTERN' + "\r\n" +
      '  - LITERAL "foo"' + "\r\n" +
      '  - WILDCARD'
  'escaped pattern':
    expression: new Pattern(
        new PatternLiteral('foo"'),
        new PatternWildcard
    )
    result: 'PATTERN' + "\r\n" +
      '  - LITERAL "foo\\""' + "\r\n" +
      '  - WILDCARD'
  'logical and':
    expression: new LogicalAnd(
        new Tag('a'),
        new Tag('b'),
        new Tag('c')
    )
    result: 'AND' + "\r\n" +
      '  - TAG "a"' + "\r\n" +
      '  - TAG "b"' + "\r\n" +
      '  - TAG "c"'
  'logical or':
    expression: new LogicalOr(
        new Tag('a'),
        new Tag('b'),
        new Tag('c')
    )
    result: 'OR' + "\r\n" +
      '  - TAG "a"' + "\r\n" +
      '  - TAG "b"' + "\r\n" +
      '  - TAG "c"'
  'logical not':
    expression: new LogicalNot(
        new Tag('a')
    )
    result: 'NOT' + "\r\n" +
    '  - TAG "a"'


describe 'TreeRenderer', ->
  renderer = new TreeRenderer("\r\n") #note we are setting the EOL

  it 'Constructor', ->
    assert.equal "\r\n", renderer.endOfLine

  describe 'Render', ->
    for description, test of renderTestVectors then do (description, test) ->
      it description, ->
        chai.assert.deepEqual renderer.render(test.expression), test.result, description
