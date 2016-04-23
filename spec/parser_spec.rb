require 'spec_helper'

describe Exceptional::Parser do
  include Exceptional::Ast

  it "parses statements with operators" do
    tokens = [
      [:NUMBER, 5],
      [:TIMES, :*],
      [:NUMBER, 2],
      [:PLUS, :+],
      [:NUMBER, 4],
      [false, false],
    ]
    expect(described_class.parse(tokens)).to eq(
      BlockNode.new(
        expressions: [
          BinopNode.new(
            op: :+,
            left: BinopNode.new(
              op: :*,
              left: NumberNode.new(value: 5),
              right: NumberNode.new(value: 2),
            ),
            right: NumberNode.new(value: 4),
          ),
        ]
      )
    )
  end

  it "parses statements where math order is important" do
    tokens = [
      [:LPAREN, "("],
      [:NUMBER, 5],
      [:PLUS, :+],
      [:NUMBER, 2],
      [:RPAREN, ")"],
      [:TIMES, :*],
      [:NUMBER, 4],
      [false, false],
    ]
    expect(described_class.parse(tokens)).to eq(
      BlockNode.new(
        expressions: [
          BinopNode.new(
            op: :*,
            left: BinopNode.new(
              op: :+,
              left: NumberNode.new(value: 5),
              right: NumberNode.new(value: 2),
            ),
            right: NumberNode.new(value: 4),
          ),
        ],
      )
    )
  end

  it "parses calls to functions without args" do
    tokens = [
      [:IDENTIFIER, "bob"],
      [:LPAREN, "("],
      [:RPAREN, ")"],
      [false, false],
    ]
    expect(described_class.parse(tokens)).to eq(
      BlockNode.new(
        expressions: [
          CallNode.new(
            expression: IdentifierNode.new(name: "bob"),
            param_list: [],
          )
        ],
      )
    )
  end

  it "parses calls to functions with complex args" do
    tokens = [
      [:IDENTIFIER, "bob"],
      [:LPAREN, "("],
      [:STRING, "toto"],
      [:PLUS, :+],
      [:STRING, "titi"],
      [:RPAREN, ")"],
      [false, false],
    ]
    expect(described_class.parse(tokens)).to eq(
      BlockNode.new(
        expressions: [
          CallNode.new(
            expression: IdentifierNode.new(name: "bob"),
            param_list: [
              BinopNode.new(
                op: :+,
                left: StringNode.new(value: "toto"),
                right: StringNode.new(value: "titi"),
              )
            ],
          )
        ],
      )
    )
  end

  it "parses assignments and local assignments" do
    tokens = [
      [:LET, "let"],
      [:IDENTIFIER, "bob"],
      [:EQ, "="],
      [:NUMBER, 1],
      [:IDENTIFIER, "toto"],
      [:EQ, "="],
      [:NUMBER, 1],
      [false, false]
    ]
    expect(described_class.parse(tokens)).to eq(
      BlockNode.new(
        expressions: [
          LocalAssignNode.new(
            binding_name: IdentifierNode.new(name: "bob"),
            value: NumberNode.new(value: 1),
          ),
          AssignNode.new(
            binding_name: IdentifierNode.new(name: "toto"),
            value: NumberNode.new(value: 1),
          )
        ]
      )
    )
  end
end
