require 'spec_helper'

include Exceptional::Ast

describe Exceptional::Runtime do

  it "can evaluate some stuff" do
    ast = BlockNode.new(
      expressions: [
        AssignNode.new(
          binding: SymbolNode.new(name: "hello"),
          value: FunctionNode.new(
            param_list: ParamListNode.new(bindings: ["x"]),
            block: BlockNode.new(
              expressions: [
                RaiseNode.new(
                  value: HashNode.new(
                    pair_list: PairListNode.new(
                      pairs: [
                        PairNode.new(
                          binding: StringNode.new(value: "syscall"),
                          value: StringNode.new(value: "puts"),
                        ),
                        PairNode.new(
                          binding: StringNode.new(value: "message"),
                          value: SymbolNode.new(name: "x"),
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
          expression: SymbolNode.new(name: "hello"),
          param_list: [
            StringNode.new(value: "world"),
          ]
        ),
      ]
    )
  end
end
