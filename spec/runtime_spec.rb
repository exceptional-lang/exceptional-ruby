require 'spec_helper'

include Exceptional::Ast

describe Exceptional::Runtime do
  it "can evaluate some stuff" do
    ast = BlockNode.new(
      expressions: [
        AssignNode.new(
          binding_name: IdentifierNode.new(name: "hello"),
          value: FunctionNode.new(
            param_list: ParamListNode.new(binding_names: ["x"]),
            block: BlockNode.new(
              expressions: [
                RaiseNode.new(
                  value: HashNode.new(
                    pair_list: PairListNode.new(
                      pairs: [
                        PairNode.new(
                          binding_name: StringNode.new(value: "io"),
                          value: StringNode.new(value: "write"),
                        ),
                        PairNode.new(
                          binding_name: StringNode.new(value: "fd"),
                          value: NumberNode.new(value: 2),
                        ),
                        PairNode.new(
                          binding_name: StringNode.new(value: "bytes"),
                          value: IdentifierNode.new(name: "x"),
                        ),
                      ]
                    )
                  )
                )
              ]
            )
          )
        ),
        CallNode.new(
          expression: IdentifierNode.new(name: "hello"),
          param_list: [
            StringNode.new(value: "world"),
          ]
        ),
      ]
    )
  end
end

describe AssignNode do
  let(:string) { StringNode.new(value: "world") }
  let(:ast) do
    AssignNode.new(
      binding_name: IdentifierNode.new(name: "hello"),
      value: string
    )
  end

  let(:environment) { Exceptional::Environment.new }

  it "modifies the environment" do
    ast.eval(environment)
    expect(environment.get("hello")).to eq(string)
  end
end
