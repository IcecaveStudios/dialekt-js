Lexer = require '../../src/Parser/lexer'
Token = require '../../src/Parser/token'

#these must be declared before the tests are run
lexTestVectors = {
  'empty expression':
    expression: ''
    result: []

  'whitespace only':
    expression: " \n \t "
    result: []

  'simple string':
    expression: 'foo-bar'
    result: [
      new Token Token.STRING, 'foo-bar', 0, 7, 1, 1
    ]

  'simple string with leading hyphen':
    expression: '-foo'
    result: [
      new Token Token.STRING, '-foo', 0, 4, 1, 1
    ]

  'simple string with leading hyphen and asterisk':
    expression: '-foo*-'
    result: [
      new Token Token.STRING, '-foo*-', 0, 6, 1, 1
    ]

  'multiple simple strings':
    expression: 'foo bar'
    result: [
      new Token Token.STRING, 'foo', 0, 3, 1, 1
      new Token Token.STRING, 'bar', 4, 3, 1, 5
    ]

  'quoted string':
    expression: '"foo bar"'
    result: [
      new Token Token.STRING, 'foo bar', 0, 9, 1, 1
    ]

  'quoted string with escaped quote':
    expression: '"foo \\"the\\" bar"'
    result: [
      new Token Token.STRING, 'foo "the" bar', 0, 17, 1, 1
    ]

  'quoted string with escaped backslash':
    expression: '"foo\\\\bar"'
    result: [
      new Token Token.STRING, 'foo\\bar', 0, 10, 1, 1
    ]

  'logical and':
    expression: 'and'
    result: [
      new Token Token.LOGICAL_AND, 'and', 0, 3, 1, 1
    ]

  'logical or':
    expression: 'or'
    result: [
      new Token Token.LOGICAL_OR, 'or', 0, 2, 1, 1
    ]

  'logical not':
    expression: 'not'
    result: [
        new Token Token.LOGICAL_NOT, 'not', 0, 3, 1, 1
    ]

  'logical operator case insensitivity':
    expression: 'aNd Or NoT'
    result: [
      new Token Token.LOGICAL_AND, 'aNd', 0, 3, 1, 1
      new Token Token.LOGICAL_OR,  'Or',  4, 2, 1, 5
      new Token Token.LOGICAL_NOT, 'NoT', 7, 3, 1, 8
    ]

  'open nesting':
    expression: '('
    result: [
        new Token Token.OPEN_BRACKET, '(', 0, 1, 1, 1
    ]

  'close nesting':
    expression: ')'
    result: [
        new Token Token.CLOSE_BRACKET, ')', 0, 1, 1, 1
    ]

  'nesting interrupts simple string':
    expression: 'foo(bar)spam'
    result: [
      new Token Token.STRING,        'foo',  0, 3, 1, 1
      new Token Token.OPEN_BRACKET,  '(',    3, 1, 1, 4
      new Token Token.STRING,        'bar',  4, 3, 1, 5
      new Token Token.CLOSE_BRACKET, ')',    7, 1, 1, 8
      new Token Token.STRING,        'spam', 8, 4, 1, 9
    ]

  'nesting interrupts simple string into quoted string':
    expression: 'foo(bar)"spam"'
    result: [
      new Token Token.STRING,        'foo',  0, 3, 1, 1
      new Token Token.OPEN_BRACKET,  '(',    3, 1, 1, 4
      new Token Token.STRING,        'bar',  4, 3, 1, 5
      new Token Token.CLOSE_BRACKET, ')',    7, 1, 1, 8
      new Token Token.STRING,        'spam', 8, 6, 1, 9
    ]

  'whitespace surrounding strings':
    expression: " \t\nfoo\tbar\nspam\t "
    result: [
      new Token Token.STRING, 'foo',   3, 3, 2, 1
      new Token Token.STRING, 'bar',   7, 3, 2, 5
      new Token Token.STRING, 'spam', 11, 4, 3, 1
    ]

  'newline inside string':
    expression: '"foo\nbar"',
    result: [
      new Token Token.STRING,
        'foo\nbar',
        0,
        8 + '\n'.length,
        1,
        1
    ]
  'newline inside string \\r\\n':
    expression: '"foo\r\nbar"',
    result: [
      new Token Token.STRING,
        'foo\r\nbar',
        0,
        8 + '\r\n'.length,
        1,
        1
    ]
}

describe 'Lexer', ->
  describe 'Lex', ->
    for description, test of lexTestVectors then do (description, test) ->
      it description, ->
        lexer = new Lexer
        # console.log description
        chai.assert.deepEqual lexer.lex(test.expression), test.result, description

