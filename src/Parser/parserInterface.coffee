InterfaceException = require '../Exception/interfaceException'

class ParserInterface

  # Parse an expression.
  #
  # @param string expression The expression to parse.
  #
  # @return ExpressionInterface The parsed expression.
  # @throws ParseException      if the expression is invalid.
  #
  parse: (expression) ->
    throw new InterfaceException

  # Parse an expression that has already beed tokenized.
  #
  # @param array<Token> The array of tokens that form the expression.
  #
  # @return ExpressionInterface The parsed expression.
  # @throws ParseException      if the expression is invalid.
  #
  parseTokens: (tokens) ->
    throw new InterfaceException
