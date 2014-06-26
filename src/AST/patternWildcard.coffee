PatternChildInterface = require './patternChildInterface'
#
# Represents a literal (exact-match) portion of a pattern expression.
#
class PatternWildcard extends PatternChildInterface
  
  # Pass this node to the appropriate method on the given visitor.
  #
  # @param VisitorInterface visitor The visitor to dispatch to.
  # @return mixed The visitation result.
  #
  accept: (visitor) ->
    visitor.visitPatternWildcard(@)

module.exports = PatternWildcard
