class Type
  constructor: (@parser, @name, @supertype)->
    unless @supertype

    @subtypes = []
    @supertype.addSubtype @

  addSubtype: (sub) ->
    @subtypes.push sub

  @initialTypes: ->
    NumberType = new Type 'Number'
    Real = new Type 'Real', NumberType
    Int = new Type 'Int', Real
    [
      Type.ANY
      NumberType
      Real
      Int
    ]

Type.ANY = new Type 'Any', null

module.exports = Type
