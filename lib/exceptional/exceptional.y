class Exceptional::Parser

token DEF DO END RAISE
token LPAREN RPAREN LBRACE RBRACE HASHROCKET COMMA
token STRING IDENTIFIER NUMBER
token EQ

rule
  Program
  : StatementList { result = Ast::BlockNode.new(expressions: val[0]) }
  ;

  StatementList
  : Statement { result = [val[0]] }
  | StatementList Statement { result = [*val[0], val[1]] }
  ;

  Statement
  : Assignment
  | Expression
  ;

  Assignment
  : IDENTIFIER EQ Expression {
    result = Ast::AssignNode.new(
      binding: Ast::IdentifierNode.new(val[0]),
      value: val[1],
    )
  }
  ;

  Expression
  : STRING { result = Ast::StringNode.new(value: val[0]) }
  ;
