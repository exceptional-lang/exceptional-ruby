require 'spec_helper'

describe Exceptional::Scanner do
  it "scans comments" do
    str = <<-STR
      # Comment
      # Other comment
      toto
    STR
    expect(subject.tokenize(str)).to eq([
      [:COMMENT, " Comment"],
      [:COMMENT, " Other comment"],
      [:IDENTIFIER, "toto"],
    ])
  end

  it "scans comparisons" do
    str = "< <= > >= == !="
    expect(subject.tokenize(str)).to eq([
      [:COMPARATOR, :<],
      [:COMPARATOR, :<=],
      [:COMPARATOR, :>],
      [:COMPARATOR, :>=],
      [:COMPARATOR, :==],
      [:COMPARATOR, :!=],
    ])
  end

  it "scans operators" do
    str = "+ - * /"
    expect(subject.tokenize(str)).to eq([
      [:PLUS, :+],
      [:MINUS, :-],
      [:TIMES, :*],
      [:DIV, :/],
    ])
  end

  it "scans brackets" do
    str = "[] {} ()"
    expect(subject.tokenize(str)).to eq([
      [:LBRACKET, "["],
      [:RBRACKET, "]"],
      [:LBRACE, "{"],
      [:RBRACE, "}"],
      [:LPAREN, "("],
      [:RPAREN, ")"],
    ])
  end

  it "scans strings" do
    str = "123 456 1029380129830912830"
    expect(subject.tokenize(str)).to eq([
      [:NUMBER, 123],
      [:NUMBER, 456],
      [:NUMBER, 1029380129830912830],
    ])
  end

  it "scans strings" do
    str = '"test titi toto"'
    expect(subject.tokenize(str)).to eq([
      [:STRING, "test titi toto"],
    ])
  end

  it "scans identifiers" do
    str = "test\ntiti\ntoto"
    expect(subject.tokenize(str)).to eq([
      [:IDENTIFIER, "test"],
      [:IDENTIFIER, "titi"],
      [:IDENTIFIER, "toto"],
    ])
  end

  it "scans hashrockets" do
    str = "=>"
    expect(subject.tokenize(str)).to eq([
      [:HASHROCKET, "=>"],
    ])
  end

  it "scans commas and periods" do
    str = ". ,"
    expect(subject.tokenize(str)).to eq([
      [:PERIOD, "."],
      [:COMMA, ","],
    ])
  end

  it "scans other keywords" do
    str = "def do end raise"
    expect(subject.tokenize(str)).to eq([
      [:DEF, "def"],
      [:DO, "do"],
      [:END, "end"],
      [:RAISE, "raise"],
    ])
  end
end
