class InterfaceException

  constructor: (message) ->
    @message = message or 'Cannot call interface method.'
    @name = "InterfaceException"


module.exports = InterfaceException
