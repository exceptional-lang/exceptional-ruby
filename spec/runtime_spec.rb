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
    LocalAssignNode.new(
      binding_name: IdentifierNode.new(name: "hello"),
      value: string
    )
  end
  let(:parent_scope) do
    Exceptional::LexicalScope.new(parent_scope: Exceptional::LexicalScope::Null)
  end
  let(:lexical_scope) do
    Exceptional::LexicalScope.new(parent_scope: parent_scope)
  end
  let(:environment) do
    Exceptional::Environment.new(lexical_scope: lexical_scope)
  end

  before do
    parent_scope.local_set("hello", "world")
  end

  it "modifies the existing binding" do
    ast.eval(environment)
    expect(lexical_scope.get("hello").value).to eq("world")
    expect(parent_scope.get("hello").value).to eq("world")
  end

  it "does not create a new binding" do
    expect(lexical_scope.get("hello")).to be_equal(
      parent_scope.get("hello")
    )
  end

  pending "it raises if the binding doesn't exist"
end

describe LocalAssignNode do
  let(:string) { StringNode.new(value: "world") }
  let(:ast) do
    LocalAssignNode.new(
      binding_name: IdentifierNode.new(name: "hello"),
      value: string
    )
  end
  let(:lexical_scope) do
    Exceptional::LexicalScope.new(parent_scope: Exceptional::LexicalScope::Null)
  end
  let(:environment) do
    Exceptional::Environment.new(lexical_scope: lexical_scope)
  end

  it "modifies the environment" do
    ast.eval(environment)
    expect(lexical_scope.get("hello").value).to eq("world")
  end
end
