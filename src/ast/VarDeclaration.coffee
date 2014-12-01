Type = require './Type'

class VarDeclaration
  constructor: (@name, @type) ->

  @parse: (parser, shouldThrow) ->
    return unless parser.expect 'Identifier', shouldThrow: shouldThrow, eat: no
    name = parser.pop().content
    return unless parser.expect ':', shouldThrow: shouldThrow, eat: yes
    return unless parser.expect 'Identifier', shouldThrow: shouldThrow, eat: no
    type = parser.pop().content
    new VarDeclaration name, parser.fetchType(type)

module.exports = VarDeclaration
