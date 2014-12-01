CompileError = (message) ->
  @name = 'CompileError'
  @message = message
  @stack = (new Error()).stack

CompileError:: = new Error()

CompileError.pass = (shouldIThrow, expected, token) ->
  err = new CompileError "Compilation error: expected `#{expected}`, " +
    "found #{token.toString()} at #{token.line}:#{token.char}"
  if shouldIThrow
    throw err
  else
    false
