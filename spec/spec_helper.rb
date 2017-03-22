$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'exceptional'
require 'pry'


module TokensHelper
  def t_let
    [:LET, "let"]
  end

  def t_def
    [:DEF, "def"]
  end

  def t_do
    [:DO, "do"]
  end

  def t_end
    [:END, "end"]
  end

  def t_rescue
    [:RESCUE, "rescue"]
  end

  def t_raise
    [:RAISE, "raise"]
  end

  def t_import
    [:IMPORT, "import"]
  end

  def t_identifier(name)
    [:IDENTIFIER, name]
  end

  def t_number(number)
    [:NUMBER, number]
  end

  def t_string(string)
    [:STRING, string]
  end

  def t_lparen
    [:LPAREN, "("]
  end

  def t_rparen
    [:RPAREN, ")"]
  end

  def t_lbrace
    [:LBRACE, "{"]
  end

  def t_rbrace
    [:RBRACE, "}"]
  end

  def t_lbracket
    [:LBRACKET, "["]
  end

  def t_rbracket
    [:RBRACKET, "]"]
  end

  def t_plus
    [:PLUS, :+]
  end

  def t_times
    [:TIMES, :*]
  end

  def t_minus
    [:MINUS, :-]
  end

  def t_div
    [:DIV, :'/']
  end

  def t_eq
    [:EQ, "="]
  end

  def t_comma
    [:COMMA, ","]
  end

  def t_period
    [:PERIOD, "."]
  end

  def t_hashrocket
    [:HASHROCKET, "=>"]
  end
end

module ValuesHelper
  def v_char_string(str)
    Exceptional::Values::CharString.new(value: str)
  end

  def v_number(num)
    Exceptional::Values::Number.new(value: num)
  end

  def v_bool(bool)
    Exceptional::Values::Boolean.new(value: bool)
  end

  def v_hashmap(hash)
    Exceptional::Values::HashMap.new(value: hash)
  end

  def v_pat(pair_list)
    Exceptional::Values::Pattern.new(pattern: pair_list)
  end

  def v_pat_literal(literal)
    Exceptional::Values::Pattern::Literal.new(value: literal)
  end

  def v_pat_variable(variable)
    Exceptional::Values::Pattern::Variable.new(name: variable)
  end
end
