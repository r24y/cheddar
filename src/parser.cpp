#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <map>
#include <string>
#include <vector>

// #Parser

enum NodeType {
  PROGRAM,
  FUNCTION_DEF,
  FUNCTION_PARAMS,
  ARG_LIST,
  ARG,
  STATEMENT,
  STATEMENTS,
  LINE_STATEMENT,
  EXPRESSION,
  NON_RETURN_EXPRESSION,
  IF_ELSE_EXPRESSION,
  FUNCTION_CALL_EXPRESSION,
  TUPLE,
  TUPLE_LIST,
  VARIABLE,
  TYPE,
  OPERATOR,
  INT_LITERAL
};

struct ASTNode {
  // Uses the TokenType enum.
  int type;
  // Child nodes.
  std::vector<ASTNode> children;
  // If this node wraps a token (e.g. Variable, IntLiteral),
  // the token will be stored here.
  struct Token *token;
};




