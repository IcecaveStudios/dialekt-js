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
        new Token Token.STRING, 'foo-bar'
    ]

  'simple string with leading hyphen':
    expression: '-foo'
    result: [
        new Token Token.STRING, '-foo'
    ]

  'simple string with leading hyphen and asterisk':
    expression: '-foo*-'
    result: [
        new Token Token.STRING, '-foo*-'
    ]

  'multiple simple strings':
    expression: 'foo bar'
    result: [
        new Token Token.STRING, 'foo'
        new Token Token.STRING, 'bar'
    ]

  'quoted string':
    expression: '"foo bar"'
    result: [
        new Token Token.STRING, 'foo bar'
    ]

  'quoted string with escaped quote':
    expression: '"foo \\"the\\" bar"'
    result: [
        new Token Token.STRING, 'foo "the" bar'
    ]

  'quoted string with escaped backslash':
    expression: '"foo\\\\bar"'
    result: [
        new Token Token.STRING, 'foo\\bar'
    ]

  'logical and':
    expression: 'and'
    result: [
        new Token Token.LOGICAL_AND, 'and'
    ]

  'logical or':
    expression: 'or'
    result: [
        new Token Token.LOGICAL_OR, 'or'
    ]

  'logical not':
    expression: 'not'
    result: [
        new Token Token.LOGICAL_NOT, 'not'
    ]

  'logical operator case insensitivity':
    expression: 'aNd Or NoT'
    result: [
        new Token Token.LOGICAL_AND, 'aNd'
        new Token Token.LOGICAL_OR, 'Or'
        new Token Token.LOGICAL_NOT, 'NoT'
    ]

  'open nesting':
    expression: '('
    result: [
        new Token Token.OPEN_BRACKET, '('
    ]

  'close nesting':
    expression: ')'
    result: [
        new Token Token.CLOSE_BRACKET, ')'
    ]

  'nesting interrupts simple string':
    expression: 'foo(bar)spam'
    result: [
        new Token Token.STRING, 'foo'
        new Token Token.OPEN_BRACKET, '('
        new Token Token.STRING, 'bar'
        new Token Token.CLOSE_BRACKET, ')'
        new Token Token.STRING, 'spam'
    ]

  'nesting interrupts simple string into quoted string':
    expression: 'foo(bar)"spam"'
    result: [
        new Token Token.STRING, 'foo'
        new Token Token.OPEN_BRACKET, '('
        new Token Token.STRING, 'bar'
        new Token Token.CLOSE_BRACKET, ')'
        new Token Token.STRING, 'spam'
    ]

  'whitespace surrounding strings':
    expression: " \t\nfoo\tbar\nspam\t "
    result: [
        new Token Token.STRING, 'foo'
        new Token Token.STRING, 'bar'
        new Token Token.STRING, 'spam'
    ]
}


describe "LexerTest", ->
  describe "Lex", ->
    for description, test of lexTestVectors then do (description, test) ->
      it description, ->
        lexer = new Lexer
        # console.log description
        chai.assert.deepEqual lexer.lex(test.expression), test.result, description

