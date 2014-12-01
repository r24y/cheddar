#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <map>
#include <string>
#include <vector>

// #Lexer

// List of tokens that Cheddar recognizes.
enum TokenType {

  // String of digits `/\d+/`
  tok_IntLiteral,

  // Alpha word `/[A-Za-z_]+/`
  tok_Identifier,

  // Function declaration
  tok_func,

  // Denote entry function
  tok_entry,

  // Return statement
  tok_return,

  // If/else
  tok_if,
  tok_else,

  // Operator `+ - <`
  tok_Operator,

  // Brackets `(){}`
  tok_open_paren,
  tok_close_paren,
  tok_open_curly,
  tok_close_curly,

  // Other punctuation
  tok_colon,
  tok_semi,

  // End of file
  tok_EOF
};

struct Token {
  int type;
  std::string content;
};

static void printToken (struct Token t) {
  std::string tokenName;
  switch (t.type) {
    case tok_IntLiteral: tokenName = "IntLiteral"; break;
    case tok_Identifier: tokenName = "Identifier"; break;
    case tok_Operator: tokenName = "Operator"; break;
    case tok_EOF: printf("<EOF>\n"); return;
    default: printf("%s ", t.content.c_str()); return;
  }
  printf("%s(%s) ", tokenName.c_str(), t.content.c_str());
}

int @leftoverChar = ' ';

// Fetch the next token from stdin.
static struct Token getNextToken () {
  int lastChar = @leftoverChar;
  std::string tokText;
  struct Token token;


  // Gobble up any whitespace.
  while (isspace(lastChar)) {
    lastChar = getchar();
  }

  // If it starts with a letter...
  if (isalpha(lastChar)) {

    // it must be some kind of word.
    tokText = lastChar;

    while (isalnum(lastChar = getchar())) {
      tokText += lastChar;
    }

    token.content = tokText;
    if (tokText == "func") {
      token.type = tok_func;
    } else if (tokText == "entry") {
      token.type = tok_entry;
    } else if (tokText == "return") {
      token.type = tok_return;
    } else if (tokText == "if") {
      token.type = tok_if;
    } else if (tokText == "else") {
      token.type = tok_else;
    } else {
      token.type = tok_Identifier;
    }

    @leftoverChar = lastChar;

    return token;
  }

  if (isdigit(lastChar)) {
    // If it's a digit then we're looking for a number.
    tokText = lastChar;

    while (isdigit(lastChar = getchar())) {
      tokText += lastChar;
    }

    @leftoverChar = lastChar;

    token.type = tok_IntLiteral;
    token.content = tokText;

    return token;
  }

  if (lastChar == EOF) {
    token.type = tok_EOF;
    return token;
  }

  // If we don't match any of the above, then we've
  // got a symbol on our hands.

  // Deal with Mr. Slash a little differently so we
  // can properly handle comments.
  if (lastChar == '/') {
    @leftoverChar = getchar();
    if (leftoverChar == '/') {
      // We've found a line comment. Gobble all the
      // characters until the end of the line.
      do {
        @leftoverChar = getchar();
      } while (leftoverChar != EOF
          && @leftoverChar != '\n'
          && @leftoverChar != '\r');

      return getNextToken();
    } else if (leftoverChar == '*') {
      // We've found a block comment. Gobble all the
      // characters until the closing tag.
      while (true) {
        if (  (leftoverChar = getchar() ) == '*'
           && (leftoverChar = getchar() ) == '/' ) {
            break;
        }
      }
      @leftoverChar = getchar();
      return getNextToken();
    }
    // If we get to this point, then it means we've got
    // a plain division sign and not a comment.
    // We have to handle it in here because we've already
    // taken the next character from the stream.
    token.content = lastChar;
    token.type = tok_Operator;
    printToken(token);
    return token;
  }

  token.content = lastChar;
  @leftoverChar = getchar();

  switch (lastChar) {
    case ':': token.type = tok_colon; break;
    case ';': token.type = tok_semi; break;
    case '(': token.type = tok_open_paren; break;
    case ')': token.type = tok_close_paren; break;
    case '{': token.type = tok_open_curly; break;
    case '}': token.type = tok_close_curly; break;
    default: token.type = tok_Operator; break;
  }

  return token;
}

void tokenizeProgram() {
  struct Token t;
  do {
    t = getNextToken();
    printToken(t);
  } while(t.type != tok_EOF);
}
