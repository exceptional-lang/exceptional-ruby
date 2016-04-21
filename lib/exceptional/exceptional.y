class Exceptional::GeneratedParser

token DEF DO END RAISE
token LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET
token COMMA PERIOD HASHROCKET
token STRING IDENTIFIER NUMBER
token EQ NEQEQ EQ GT GTE LT LTE
token COMPARATOR
token PLUS MINUS TIMES DIV
token COMMENT

prechigh
  left     TIMES DIV
  left     PLUS MINUS
  right    EQ
preclow

rule
  Program
  : StatementList { result = Ast::BlockNode.new(expressions: val[0]) }
  ;

  StatementList
  : Statement { result = [val[0]] }
  | StatementList Statement { result = [*val[0], val[1]] }
  ;

  Statement
  : CallStatement
  | AdditionStatement
  ;

  AdditionStatement
  : MultiplicativeStatement
  | AdditionStatement PLUS MultiplicativeStatement { result = Ast::BinopNode.new(op: :+, left: val[0], right: val[2]) }
  | AdditionStatement MINUS MultiplicativeStatement { result = Ast::BinopNode.new(op: :-, left: val[0], right: val[2]) }
  ;

  MultiplicativeStatement
  : PrimaryStatement
  | MultiplicativeStatement TIMES PrimaryStatement { result = Ast::BinopNode.new(op: :*, left: val[0], right: val[2]) }
  | MultiplicativeStatement DIV PrimaryStatement { result = Ast::BinopNode.new(op: :'/', left: val[0], right: val[2]) }
  ;

  CallStatement
  : Identifier LPAREN ArgumentList RPAREN { result = Ast::CallNode.new(expression: val[0], param_list: val[2]) }
  ;

  Receiver
  : Identifier
  ;

  ArgumentList
  :           { result = [] }
  | Value     { result = [val[0]] }
  | Value COMMA ArgumentList { result = [val[0], *val[2]] }
  ;

  PrimaryStatement
  : Value
  ;

  Value
  : String
  | Number
  | PropertyAccess
  ;

  PropertyAccess
  : Identifier
  | Identifier PERIOD Identifier
  ;

  Identifier
  : IDENTIFIER { result = Ast::IdentifierNode.new(name: val[0]) }

  String
  : STRING { result = Ast::StringNode.new(value: val[0]) }
  ;

  Number
  : NUMBER { result = Ast::NumberNode.new(value: val[0]) }
  ;
