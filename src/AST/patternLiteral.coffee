PatternChildInterface = require './patternChildInterface'
#
# Represents a literal (exact-match) portion of a pattern expression.
#
class PatternLiteral extends PatternChildInterface
  
  #
  # @param {string} string The string to match.
  #
  constructor: (string) ->
    @string = string

  # Pass this node to the appropriate method on the given visitor.
  #
  # @param {VisitorInterface} visitor The visitor to dispatch to.
  # @return {mixed} The visitation result.
  #
  accept: (visitor) ->
    visitor.visitPatternLiteral(@)

module.exports = PatternLiteral
