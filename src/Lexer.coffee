_ = require 'lodash'

Token = require './Token'

isalnum = (c) -> c and /\w/.test(c)
isalpha = (c) -> c and /[a-zA-Z]/.test(c)
isdigit = (c) -> c and /[0-9.]/.test(c)
isspace = (c) -> c and /\s/.test(c)
isnl = (c) -> c in ['\n','\r']

isascii = (c) -> c not instanceof Token

EOF = null

class Lexer
  constructor: (@buffer) ->
    @leftoverChar = ' '
    @position = 0
    @line = 0
    @char = 0
    unless Buffer.isBuffer @buffer
      @buffer = new Buffer @buffer

  getChar: ->
    if @position < @buffer.length
      c = String.fromCharCode @buffer[@position++]
      if c in ['\n','\r']
        @char = 0
        @line++
      else
        @char++
      c
    else
      EOF

  isDone: -> @position >= @buffer.length

  readToken: ->
    lastChar = @leftoverChar
    tokText = ''

    # Gobble up any whitespace.
    while isspace lastChar

      lastChar = @getChar()

    if isalpha lastChar

      # We've found the start of a word.
      tokText = lastChar

      while isalnum(lastChar = @getChar())
        tokText += lastChar

      tokenType = Token.Types.keywords().filter (t) -> t.name is tokText

      @leftoverChar = lastChar

      return new Token (tokenType[0] or Token.Types.IDENTIFIER), tokText, line: @line, char: @char

    if isdigit lastChar

      # Right now we're only concerning ourselves with integer literals.
      # If we find a token that starts with a digit, then it's an integer.
      tokText = lastChar

      while isdigit(lastChar = @getChar())
        tokText += lastChar


      @leftoverChar = lastChar

      return new Token Token.Types.INT_LITERAL, tokText, line: @line, char: @char

    if @isDone()

      return new Token(Token.Types.EOF, '', line: @line, char: @char)

    # Deal with slashes a little differently so we can have comments.
    if lastChar is '/'

      @leftoverChar = @getChar()
      if @leftoverChar is '/'
        # We've just found two slashes in a row. Gobble all the characters
        # up to the end of the line.
        @leftoverChar = @getChar() until @leftoverChar in [EOF, '\n', '\r']

        return @readToken()

      else if @leftoverChar is '*'

        # We've found the start of a block comment.
        loop
          if ((leftoverChar = @getChar()) is '*') and ((leftoverChar = @getChar()) is '/')
            break

        @leftoverChar = @getChar()

        return @readToken()

      # If we've made it this far without returning something, then it means we've just got
      # a plain slash operator. We have to handle it in here because we've already stolen
      # the '/' character from the stream.
      return new Token(Token.Types.OPERATOR, '/', line: @line, char: @char)


    # Handle all other characters here.
    tokText = lastChar
    @leftoverChar = @getChar()
    tokenType = Token.Types.punctuation().filter (t) -> t.name is tokText
    return new Token((tokenType[0] or Token.Types.OPERATOR), tokText, line: @line, char: @char)

Lexer.Token = Token

module.exports = Lexer
