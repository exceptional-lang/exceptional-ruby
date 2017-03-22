require "spec_helper"

include Exceptional::Ast

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

  it "parses hashes" do
    tokens = [
      t_lbrace,
      t_string("x"),
      t_hashrocket,
      t_string("toto"),
      t_comma,
      t_identifier("y"),
      t_hashrocket,
      t_lbrace,
      t_string("nested"),
      t_hashrocket,
      t_identifier("hash"),
      t_comma,
      t_string("expression"),
      t_hashrocket,
      t_identifier("left"),
      t_plus,
      t_number(4),
      t_rbrace,
      t_comma,
      t_string("z"),
      t_hashrocket,
      t_lbrace,
      t_rbrace,
      t_rbrace,
    ]
    expect(described_class.parse(tokens)).to eq(
      BlockNode.new(
        expressions: [
          HashNode.new(
            pair_list: [
              [
                StringNode.new(value: "x"),
                StringNode.new(value: "toto"),
              ],
              [
                IdentifierNode.new(name: "y"),
                HashNode.new(
                  pair_list: [
                    [
                      StringNode.new(value: "nested"),
                      IdentifierNode.new(name: "hash"),
                    ],
                    [
                      StringNode.new(value: "expression"),
                      BinopNode.new(
                        op: :+,
                        left: IdentifierNode.new(name: "left"),
                        right: NumberNode.new(value: 4),
                      ),
                    ]
                  ]
                )
              ],
              [
                StringNode.new(value: "z"),
                HashNode.new(pair_list: [])
              ],
            ]
          ),
        ],
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
            param_list: ParamListNode.new(
              binding_names: [
                IdentifierNode.new(name: "x"),
                IdentifierNode.new(name: "y"),
              ],
            ),
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

  it "parses rescue blocks" do
    tokens = [
      t_rescue,
      t_lparen,
      t_lbrace,
      t_rbrace,
      t_rparen,
      t_do,
      t_end,
    ]
    expect(described_class.parse(tokens)).to eq(
      BlockNode.new(
        expressions: [
          RescueNode.new(
            pattern: PatternNode.new(
              value: HashNode.new(pair_list: []),
            ),
            block_node: BlockNode.new(expressions: []),
          )
        ],
      )
    )
  end

  it "parses raise statements" do
    tokens = [
      t_raise,
      t_lparen,
      t_lbrace,
      t_rbrace,
      t_rparen,
    ]
    expect(described_class.parse(tokens)).to eq(
      BlockNode.new(
        expressions: [
          RaiseNode.new(
            value: HashNode.new(pair_list: []),
          )
        ],
      )
    )
  end

  it "parses hash access via dot-syntax" do
    tokens = [
      t_identifier("toto"),
      t_period,
      t_identifier("titi"),
      t_period,
      t_identifier("tutu"),
    ]
    expect(described_class.parse(tokens)).to eq(
      BlockNode.new(
        expressions: [
          HashAccessNode.new(
            receiver: HashAccessNode.new(
              receiver: IdentifierNode.new(name: "toto"),
              property: StringNode.new(value: "titi"),
            ),
            property: StringNode.new(value: "tutu"),
          ),
        ]
      )
    )
  end

  it "parses hash access via square brackets-syntax" do
    tokens = [
      t_identifier("toto"),
      t_lbracket,
      t_identifier("titi"),
      t_rbracket,
      t_lbracket,
      t_string("tutu"),
      t_rbracket,
    ]
    expect(described_class.parse(tokens)).to eq(
      BlockNode.new(
        expressions: [
          HashAccessNode.new(
            receiver: HashAccessNode.new(
              receiver: IdentifierNode.new(name: "toto"),
              property: IdentifierNode.new(name: "titi"),
            ),
            property: StringNode.new(value: "tutu"),
          ),
        ]
      )
    )
  end

  it "parses import calls" do
    tokens = [
      t_import,
      t_lparen,
      t_string("test"),
      t_rparen,
    ]
    expect(described_class.parse(tokens)).to eq(
      BlockNode.new(
        expressions: [
          ImportNode.new(name: StringNode.new(value: "test")),
        ],
      )
    )
  end
end
