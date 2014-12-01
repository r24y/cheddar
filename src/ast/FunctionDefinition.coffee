VarDeclaration = require './VarDeclaration'

class FunctionDefinition

  @MODIFIERS: ['entry']

  constructor: ->
    @vars = []

  pushVar: (myvar) ->
    @vars.push myvar

  @parse: (parser, shouldThrow) ->
    modifiers = []

    func = new FunctionDefinition()

    # Check for any modifiers. Right now we only observe `entry`, but more are in the works.
    while (tok = parser.peek()).type.keyword and tok.type.name in FunctionDefinition.MODIFIERS
      modifiers.push parser.pop().type.name

    # Once we run out of modifiers, we should come across the `func` keyword.
    return unless parser.expect 'func', shouldThrow: shouldThrow, eat: yes

    # Expect the function's name to be next.
    return unless parser.expect 'Identifier', shouldThrow: shouldThrow, eat: no
    func.name = parser.pop().content

    # Expect an open-paren to start the argument list.
    return unless parser.expect '(', shouldThrow: shouldThrow, eat: yes

    # Parse the list of arguments and their types.
    loop
      if parser.nextTypeIs ')'
        break
      nextVar = VarDeclaration.parse(parser, false)
      if nextVar
        return unless parser.expect [',',')'], shouldThrow: shouldThrow, eat: no
        if parser.nextTypeIs ','
          parser.eat()

    # Once we run out of arguments, expect a close-paren.
    return unless parser.expect ')', shouldThrow: shouldThrow, eat: yes

    func

module.exports = FunctionDefinition
