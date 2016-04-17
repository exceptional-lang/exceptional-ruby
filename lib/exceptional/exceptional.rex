class Exceptional::Scanner
macro
  BLANK [\ \t\n]+
  IDENTIFIER [[:alpha:]_][\w]*
  NUMBER \d+
rule
  "[^"]*" { [:STRING, text[1..-2]] }
  \#.* { [:COMMENT, text[1..-1]] }

  , { [:COMMA, text] }
  \. { [:PERIOD, text] }
  => { [:HASHROCKET, text] }

  == { [:COMPARE, text.to_sym] }
  != { [:COMPARE, text.to_sym] }
  >= { [:COMPARE, text.to_sym] }
  > { [:COMPARE, text.to_sym] }
  <= { [:COMPARE, text.to_sym] }
  < { [:COMPARE, text.to_sym] }

  = { [:EQ, text] }
  \+ { [:OP, text.to_sym] }
  \- { [:OP, text.to_sym] }
  \* { [:OP, text.to_sym] }
  \/ { [:OP, text.to_sym] }

  \( { [:LPAREN, text] }
  \) { [:RPAREN, text] }
  \{ { [:LBRACE, text] }
  \} { [:RBRACE, text] }
  \[ { [:LBRACKET, text] }
  \] { [:RBRACKET, text] }

  def { [:DEF, text] }
  do { [:DO, text] }
  end { [:END, text] }
  raise { [:RAISE, text] }

  {IDENTIFIER} { [:IDENTIFIER, text] }
  {NUMBER} { [:NUMBER, text.to_i] }
  {BLANK}
inner
  def tokenize(code)
    scan_setup(code)
    tokens = []
    while token = next_token
      tokens << token
    end
    tokens
  end
end
