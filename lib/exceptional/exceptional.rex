class Exceptional::Scanner
macro
  BLANK [\ \t]+
  SYMBOL [\w_][\w\d_]*
  NUMBER \d+
rule
  "[^"]*" { [:STRING, text[1, -2]] }
  = { [:EQ, text] }
  def { [:DEF, text] }
  do { [:DO, text] }
  end { [:END, text] }
  \( { [:LPAREN, text] }
  \) { [:RPAREN, text] }
  raise { [:RAISE, text] }
  \{ { [:LBRACE, text] }
  \} { [:RBRACE, text] }
  , { [:COMMA, text] }
  => { [:HASHROCKET, text] }
  {SYMBOL} { [:SYMBOL, text] }
  {NUMBER} { [:NUMBER, text] }
  {BLANK}
end
