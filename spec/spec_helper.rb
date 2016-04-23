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
end
