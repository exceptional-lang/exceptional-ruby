class Exceptional::GeneratedParser

token LET DEF DO END RAISE RESCUE
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
  :                         { result = [] }
  | Statement               { result = [val[0]] }
  | StatementList Statement { result = [*val[0], val[1]] }
  ;

  Statement
  : CallStatement
  | AssignmentStatement
  | RescueStatement
  | RaiseStatement
  ;

  RaiseStatement
  : RAISE LPAREN Hash RPAREN { result = Ast::RaiseNode.new(value: val[2]) }
  ;

  RescueStatement
  : RESCUE RescuePattern Block { result = Ast::RescueNode.new(pattern: val[1], block_node: val[2]) }
  ;

  RescuePattern
  : LPAREN Hash RPAREN { result = Ast::PatternNode.new(value: val[1]) }
  ;

  AssignmentStatement
  : LocalAssignmentStatement
  | NonlocalAssignmentStatement
  ;

  LocalAssignmentStatement
  : LET NonlocalAssignmentStatement { result = Ast::LocalAssignNode.new(binding_name: val[1].binding_name, value: val[1].value) }
  ;

  NonlocalAssignmentStatement
  : AdditionStatement
  | FunctionStatement
  | Identifier EQ NonlocalAssignmentStatement { result = Ast::AssignNode.new(binding_name: val[0], value: val[2]) }
  ;

  FunctionStatement
  : DEF LPAREN FunctionArgumentList RPAREN Block { result = Ast::FunctionNode.new(param_list: Ast::ParamListNode.new(binding_names: val[2]), block_node: val[4]) }
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
  : PropertyAccess LPAREN ArgumentList RPAREN { result = Ast::CallNode.new(expression: val[0], param_list: val[2]) }
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
  | Hash
  ;

  PropertyAccess
  : Receiver
  | Receiver PERIOD Identifier { result = Ast::HashAccessNode.new(receiver: val[0], property: Ast::StringNode.new(value: val[2].name) ) }
  | Receiver LBRACKET PrimaryStatement RBRACKET { result = Ast::HashAccessNode.new(receiver: val[0], property: val[2]) }
  ;

  Receiver
  : Identifier
  | PropertyAccess
  ;

  Hash
  : LBRACE HashPairList RBRACE { result = Ast::HashNode.new(pair_list: val[1]) }
  ;

  HashPairList
  :                             { result = [] }
  | HashPair                    { result = [val[0]] }
  | HashPair COMMA HashPairList { result = [val[0], *val[2]] }
  ;

  HashPair
  : AdditionStatement HASHROCKET AdditionStatement { result = [val[0], val[2]] }
  ;

  Identifier
  : IDENTIFIER { result = Ast::IdentifierNode.new(name: val[0]) }

  String
  : STRING { result = Ast::StringNode.new(value: val[0]) }
  ;

  Number
  : NUMBER { result = Ast::NumberNode.new(value: val[0]) }
  ;
