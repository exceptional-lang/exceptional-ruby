require 'spec_helper'

describe Exceptional::Parser do
  include TokensHelper
  include Exceptional::Ast

  it "parses statements with operators" do
    tokens = [
      t_number(5),
      t_times,
      t_number(2),
      t_plus,
      t_number(4)
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
      t_lparen,
      t_number(5),
      t_plus,
      t_number(2),
      t_rparen,
      t_times,
      t_number(4),
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
      t_identifier("bob"),
      t_lparen,
      t_rparen,
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
      t_identifier("bob"),
      t_lparen,
      t_string("toto"),
      t_plus,
      t_string("titi"),
      t_rparen,
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
      t_let,
      t_identifier("bob"),
      t_eq,
      t_number(1),
      t_identifier("toto"),
      t_eq,
      t_number(1),
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

  it "parses function definition" do
    tokens = [
      t_def,
      t_lparen,
      t_identifier("x"),
      t_comma,
      t_identifier("y"),
      t_rparen,
      t_do,
      t_identifier("x"),
      t_plus,
      t_identifier("y"),
      t_end,
    ]
    expect(described_class.parse(tokens)).to eq(
      BlockNode.new(
        expressions: [
          FunctionNode.new(
            param_list: [
              IdentifierNode.new(name: "x"),
              IdentifierNode.new(name: "y"),
            ],
            block_node: BlockNode.new(
              expressions: [
                BinopNode.new(
                  op: :+,
                  left: IdentifierNode.new(name: "x"),
                  right: IdentifierNode.new(name: "y"),
                )
              ]
            )
          )
        ]
      )
    )
  end
end
