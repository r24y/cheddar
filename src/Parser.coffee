CompileError = require './CompileError'
Type = require './Type'

_ = require 'lodash'

class Parser

  constructor: (@lexer) ->
    @tokenStack = []
    @types = Type.initialTypes()

  pop: ->
    if @tokenStack.length
      @tokenStack.pop()
    else
      @lexer.readToken()

  eat: -> @pop()

  push: (tok) -> @tokenStack.push tok

  peek: ->
    tok = @pop()
    @replaceToken tok
    tok

  nextTypeIs: (name) -> @peek().type.name is name
  nextTypeIsnt: (name) -> not @nextTypeIs name
  nextTypeIn: (types) -> types.filter((t) => @nextTypeIs t).length

  expect: (expected, opt={eat:no}) ->
    unless _.isArray expected
      expected = [expected]
    unless @nextTypeIn expected
      tok = if opt.eat then @pop() else @peek()
      CompileError.pass opt.shouldThrow, expected.join('`, `'), tok
    else
      if opt.eat then @eat()
      true

  fetchType: (name) ->
    _.findWhere @types, {name: name}
