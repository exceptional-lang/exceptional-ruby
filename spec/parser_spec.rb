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
    ]
    expect(described_class.new(tokens).parse).to eq(
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
end
