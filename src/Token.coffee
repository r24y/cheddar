_ = require 'lodash'

class TokenType
  constructor: (@name, opt={}) ->
    {
      @content
      @punctuation
      @keyword
    } = opt

class Token
  constructor: (@type, @content, opt={}) ->
    {@line, @char} = opt
  toString: ->
    if @type.content
      "#{@type.name}(#{@content})"
    else
      @type.name

Token.Types =
  INT_LITERAL: new TokenType 'IntLiteral',   content: yes
  IDENTIFIER : new TokenType 'Identifier',   content: yes
  FUNC       : new TokenType 'func',         keyword: yes
  ENTRY      : new TokenType 'entry',        keyword: yes
  RETURN     : new TokenType 'return',       keyword: yes
  IF         : new TokenType 'if',           keyword: yes
  ELSE       : new TokenType 'else',         keyword: yes
  OPERATOR   : new TokenType 'Operator',     content: yes
  OPEN_PAREN : new TokenType '(',            punctuation: yes
  CLOSE_PAREN: new TokenType ')',            punctuation: yes
  OPEN_CURLY : new TokenType '{',            punctuation: yes
  CLOSE_CURLY: new TokenType '}',            punctuation: yes
  COLON      : new TokenType ':',            punctuation: yes
  SEMICOLON  : new TokenType ';',            punctuation: yes
  COMMA      : new TokenType ',',            punctuation: yes
  EOF        : new TokenType '«EOF»'

  keywords: ->
    _.values(Token.Types).filter (type) -> type.keyword

  withContent: ->
    _.values(Token.Types).filter (type) -> type.content

  punctuation: ->
    _.values(Token.Types).filter (type) -> type.punctuation

module.exports = Token
