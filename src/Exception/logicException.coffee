# Custom error object
# https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/throw
class LogicException

  constructor: (message) ->
    @message = message
    @name = "LogicException"


module.exports = LogicException
