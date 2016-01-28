require 'spec_helper'

include Exceptional::Ast

describe Exceptional::Runtime do
  let(:string) { StringNode.new(value: "world") }
  let(:parent_scope) do
    Exceptional::Runtime::LexicalScope.new(
      parent_scope: Exceptional::Runtime::LexicalScope::Null
    )
  end
  let(:lexical_scope) do
    Exceptional::Runtime::LexicalScope.new(
      parent_scope: parent_scope,
    )
  end

  # it "can evaluate some stuff" do
  #   BlockNode.new(
  #     expressions: [
  #       AssignNode.new(
  #         binding_name: IdentifierNode.new(name: "hello"),
  #         value: FunctionNode.new(
  #           param_list: ParamListNode.new(parameters: ["x"]),
  #           block: BlockNode.new(
  #             expressions: [
  #               RaiseNode.new(
  #                 value: HashNode.new(
  #                   pair_list: PairListNode.new(
  #                     pairs: [
  #                       PairNode.new(
  #                         binding_name: StringNode.new(value: "io"),
  #                         value: StringNode.new(value: "write"),
  #                       ),
  #                       PairNode.new(
  #                         binding_name: StringNode.new(value: "fd"),
  #                         value: NumberNode.new(value: 2),
  #                       ),
  #                       PairNode.new(
  #                         binding_name: StringNode.new(value: "bytes"),
  #                         value: IdentifierNode.new(name: "x"),
  #                       ),
  #                     ]
  #                   )
  #                 )
  #               )
  #             ]
  #           )
  #         )
  #       ),
  #       CallNode.new(
  #         expression: IdentifierNode.new(name: "hello"),
  #         param_list: [
  #           StringNode.new(value: "world"),
  #         ]
  #       ),
  #     ]
  #   )
  # end


  describe AssignNode do
    let(:ast) do
      AssignNode.new(
        binding_name: IdentifierNode.new(name: "hello"),
        value: StringNode.new(value: "test")
      )
    end
    let(:environment) do
      Exceptional::Runtime::Environment.new(lexical_scope: lexical_scope)
    end

    before do
      parent_scope.local_set("hello", "world")
    end

    it "modifies the existing binding" do
      ast.eval(environment)
      expect(lexical_scope.get("hello")).to eq("test")
      expect(parent_scope.get("hello")).to eq("test")
    end

    it "does not create a new binding" do
      expect(lexical_scope.get("hello")).to be_equal(
        parent_scope.get("hello")
      )
    end

    pending "it raises if the binding doesn't exist"
  end

  describe LocalAssignNode do
    let(:ast) do
      LocalAssignNode.new(
        binding_name: IdentifierNode.new(name: "hello"),
        value: string
      )
    end
    let(:environment) do
      Exceptional::Runtime::Environment.new(lexical_scope: parent_scope)
    end

    it "modifies the environment" do
      ast.eval(environment)
      expect(lexical_scope.get("hello")).to eq("world")
    end
  end

  describe FunctionNode do
    let(:block) do
      BlockNode.new(
        expressions: [
          LocalAssignNode.new(
            binding_name: IdentifierNode.new(name: "hello"),
            value: string
          ),
        ]
      )
    end

    let(:ast) do
      FunctionNode.new(
        param_list: ParamListNode.new(binding_names: ["x"]),
        block: block
      )
    end
    let(:environment) do
      Exceptional::Runtime::Environment.new(lexical_scope: parent_scope)
    end

    it "creates a lambda that wraps the block and the lexical scope" do
      value = ast.eval(environment)
      expect(value).to be_a(Exceptional::Values::Lambda)
      expect(value.lexical_scope).to eq(lexical_scope)
      expect(value.param_list).to eq(["x"])
      expect(value.block).to eq(block)
    end
  end

  describe IdentifierNode do
    let(:ast) do
      IdentifierNode.new(name: "hello")
    end
    let(:environment) do
      Exceptional::Runtime::Environment.new(lexical_scope: parent_scope)
    end

    before do
      parent_scope.local_set("hello", "world")
    end

    it "fetches the value from the environment" do
      expect(ast.eval(environment)).to eq("world")
    end
  end

  describe CallNode do
    let(:call_param_list) { [] }
    let(:ast) do
      CallNode.new(
        expression: IdentifierNode.new(name: "hello"),
        param_list: call_param_list,
      )
    end
    let(:environment) do
      Exceptional::Runtime::Environment.new(lexical_scope: parent_scope)
    end
    let(:parameter_names) { [] }
    let(:function) do
      Exceptional::Values::Lambda.new(
        param_list: parameter_names,
        block: BlockNode.new(expressions: []),
        lexical_scope: environment.lexical_scope,
      )
    end

    before do
      parent_scope.local_set("parent_variable", "something")
      parent_scope.local_set("hello", function)
    end

    it "creates a new stackframe" do
      expect(environment).to receive(:stack)
      ast.eval(environment)
    end

    context "without parameters" do
      it "finds the function in the environment and calls it" do
        expect(function).to receive(:call)
          .with(environment, [])
        ast.eval(environment)
      end
    end

    context "with parameters" do
      let(:parameter_names) { ["x"] }
      let(:call_param_list) { [IdentifierNode.new(name:"parent_variable")] }

      it "fetches the parameters and calls the lambda" do
        expect(function).to receive(:call).with(environment, ["something"])
        ast.eval(environment)
      end
    end

    context "when calling a non-lambda" do
      pending "it fails"
    end
  end
end

describe Exceptional::Values do
  let(:parent_scope) do
    Exceptional::Runtime::LexicalScope.new(
      parent_scope: Exceptional::Runtime::LexicalScope::Null
    )
  end

  describe Exceptional::Values::Lambda do
    let(:environment) do
      Exceptional::Runtime::Environment.new(
        lexical_scope: parent_scope,
      )
    end
    let(:function) do
      Exceptional::Values::Lambda.new(
        param_list: ["x"],
        block: BlockNode.new(expressions: []),
        lexical_scope: environment.lexical_scope,
      )
    end

    it "creates a new lexical scope" do
      function.call(environment, ["something"])
      expect(environment.lexical_scope).not_to eq(parent_scope)
      expect(environment.lexical_scope.parent_scope).to eq(parent_scope)
    end

    it "creates local bindings for the parameters" do
      function.call(environment, ["something"])
      expect(environment.lexical_scope.get("x")).to eq("something")
    end
  end
end
