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

  == { [:COMPARATOR, text.to_sym] }
  != { [:COMPARATOR, text.to_sym] }
  >= { [:COMPARATOR, text.to_sym] }
  > { [:COMPARATOR, text.to_sym] }
  <= { [:COMPARATOR, text.to_sym] }
  < { [:COMPARATOR, text.to_sym] }

  = { [:EQ, text] }
  \+ { [:PLUS, text.to_sym] }
  \- { [:MINUS, text.to_sym] }
  \* { [:TIMES, text.to_sym] }
  \/ { [:DIV, text.to_sym] }

  \( { [:LPAREN, text] }
  \) { [:RPAREN, text] }
  \{ { [:LBRACE, text] }
  \} { [:RBRACE, text] }
  \[ { [:LBRACKET, text] }
  \] { [:RBRACKET, text] }

  let { [:LET, text] }
  def { [:DEF, text] }
  do { [:DO, text] }
  end { [:END, text] }
  raise { [:RAISE, text] }
  rescue { [:RESCUE, text] }
  import { [:IMPORT, text] }

  {IDENTIFIER} { [:IDENTIFIER, text] }
  {NUMBER} { [:NUMBER, text.to_i] }
  {BLANK}
inner
  def self.tokenize(code)
    instance = new
    instance.scan_setup(code)
    tokens = []
    while token = instance.next_token
      tokens << token
    end
    tokens
  end
end
