class Exceptional::GeneratedParser

token LET DEF DO END RAISE
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
  : Statement               { result = [val[0]] }
  | StatementList Statement { result = [*val[0], val[1]] }
  ;

  Statement
  : CallStatement
  | AssignmentStatement
  ;

  AssignmentStatement
  : LocalAssignmentStatement
  | NonlocalAssignmentStatement
  ;

  LocalAssignmentStatement
  : LET NonlocalAssignmentStatement { result = LocalAssignNode.new(binding_name: val[1].binding_name, value: val[1].value) }
  ;

  NonlocalAssignmentStatement
  : AdditionStatement
  | Identifier EQ AdditionStatement { result = Ast::AssignNode.new(binding_name: val[0], value: val[2]) }
  | Identifier EQ FunctionStatement { result = Ast::AssignNode.new(binding_name: val[0], value: val[2]) }
  ;

  FunctionStatement
  : DEF LPAREN FunctionArgumentList RPAREN Block { result = Ast::FunctionNode.new(param_list: val[2]) }
  ;

  Block
  : DO Program END { result = val[1] }

  FunctionArgumentList
  :                               { result = [] }
  | Identifier                    { result = [val[0]] }
  | Identifier COMMA ArgumentList { result = [val[0], *val[2]] }
  ;

  AdditionStatement
  : MultiplicativeStatement
  | AdditionStatement PLUS MultiplicativeStatement  { result = Ast::BinopNode.new(op: :+, left: val[0], right: val[2]) }
  | AdditionStatement MINUS MultiplicativeStatement { result = Ast::BinopNode.new(op: :-, left: val[0], right: val[2]) }
  ;

  MultiplicativeStatement
  : PrimaryStatement
  | MultiplicativeStatement TIMES PrimaryStatement  { result = Ast::BinopNode.new(op: :*, left: val[0], right: val[2]) }
  | MultiplicativeStatement DIV PrimaryStatement    { result = Ast::BinopNode.new(op: :'/', left: val[0], right: val[2]) }
  ;

  CallStatement
  : Identifier LPAREN ArgumentList RPAREN { result = Ast::CallNode.new(expression: val[0], param_list: val[2]) }
  ;

  Receiver
  : Identifier
  ;

  ArgumentList
  :                                      { result = [] }
  | AdditionStatement                    { result = [val[0]] }
  | AdditionStatement COMMA ArgumentList { result = [val[0], *val[2]] }
  ;

  PrimaryStatement
  : Value
  | LPAREN Statement RPAREN { result = val[1] }
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
