nopt = require 'nopt'

Lexer = require './Lexer'

fullOptions =
  tokenize: Boolean

shortOptions =
  t: ['--tokenize']
  '?': ['--help']
  'h': ['--help']

module.exports = ->
  opts = nopt(fullOptions, shortOptions, process.argv, 2)
  if opts.help
    console.log """

    Usage: cheddarc [options] <source files>

    Options:

      -t, --tokenize:      Print tokens found in source and exit. For debugging.
      -h, --help:          Print this help message.

    """
    return
  if opts.tokenize
    process.stdin.once 'readable', ->
      prog = ''
      process.stdin.on 'data', (dat) ->
        prog += dat.toString()

      process.stdin.once 'end', ->
        lex = new Lexer(prog)
        tokens = []
        loop
          tok = lex.readToken()
          tokens.push(tok)
          if tok.type is Lexer.Token.Types.EOF
            break
        console.log tokens.map((tok)->tok.toString()).join(' ')
