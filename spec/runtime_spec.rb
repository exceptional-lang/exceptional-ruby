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
  #           block_node: BlockNode.new(
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
      world = Exceptional::Values::CharString.new(value: "world")
      parent_scope.local_set("hello", world)
    end

    it "modifies the existing binding" do
      ast.eval(environment)
      expect(lexical_scope.get("hello")).to eq(
        Exceptional::Values::CharString.new(value: "test")
      )
      expect(parent_scope.get("hello")).to eq(
        Exceptional::Values::CharString.new(value: "test")
      )
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
      expect(lexical_scope.get("hello")).to eq(
        Exceptional::Values::CharString.new(value: "world")
      )
    end
  end

  describe BinopNode do
    let(:environment) do
      Exceptional::Runtime::Environment.new(lexical_scope: parent_scope)
    end

    {
      :+ => {
        [1, 1] => 2,
        [1, -1] => 0,
      },
      :- => {
        [1, 1] => 0,
        [1, -1] => 2,
      },
    }.each do |(operator, tests)|
      context operator do
        tests.each do |((left, right), result)|
          it "#{left} #{operator} #{right} is #{result}" do
            node = BinopNode.new(
              op: operator,
              left: NumberNode.new(value: left),
              right: NumberNode.new(value: right),
            )

            expect(node.eval(environment)).to eq(Exceptional::Values::Number.new(value: result))
          end
        end
      end
    end
  end

  describe ComparisonNode do
    let(:environment) do
      Exceptional::Runtime::Environment.new(lexical_scope: parent_scope)
    end

    {
      :== => {
        [4, 4] => true,
        [4, 5] => false,
      },
      :!= => {
        [4, 4] => false,
        [4, 5] => true,
      },
      :< => {
        [4, 5] => true,
        [4, 4] => false,
        [4, 3] => false,
      },
      :<= => {
        [4, 5] => true,
        [4, 4] => true,
        [4, 3] => false,
      },
      :> => {
        [4, 5] => false,
        [4, 4] => false,
        [4, 3] => true,
      },
      :>= => {
        [4, 5] => false,
        [4, 4] => true,
        [4, 3] => true,
      },
    }.each do |(operator, tests)|
      context operator do
        tests.each do |((left, right), result)|
          it "#{left} #{operator} #{right} is #{result}" do
            node = ComparisonNode.new(
              op: operator,
              left: NumberNode.new(value: left),
              right: NumberNode.new(value: right),
            )

            expect(node.eval(environment)).to eq(Exceptional::Values::Boolean.new(value: result))
          end
        end
      end
    end

    {
      :== => {
        ["a", "a"] => true,
        ["a", "b"] => false,
      },
      :!= => {
        ["a", "a"] => false,
        ["a", "b"] => true,
      },
      :< => {
        ["a", "b"] => true,
        ["a", "a"] => false,
        ["aa", "ab"] => true,
        ["ab", "aa"] => false,
      },
      :<= => {
        ["a", "a"] => true,
        ["a", "b"] => true,
        ["b", "a"] => false,
      },
      :> => {
        ["a", "a"] => false,
        ["b", "a"] => true,
        ["ab", "aa"] => true,
        ["aa", "ab"] => false
      },
      :>= => {
        ["a", "a"] => true,
        ["b", "a"] => true,
        ["a", "b"] => false,
      },
    }.each do |(operator, tests)|
      context operator do
        tests.each do |((left, right), result)|
          it "#{left} #{operator} #{right} is #{result}" do
            node = ComparisonNode.new(
              op: operator,
              left: StringNode.new(value: left),
              right: StringNode.new(value: right),
            )

            expect(node.eval(environment)).to eq(Exceptional::Values::Boolean.new(value: result))
          end
        end
      end
    end

    {
      :== => {
        [true, true] => true,
        [true, false] => false,
        [false, true] => false,
        [true, true] => true,
      },
      :!= => {
        [true, true] => false,
        [false, true] => true,
      },
    }.each do |(operator, tests)|
      context operator do
        tests.each do |((left, right), result)|
          it "#{left} #{operator} #{right} is #{result}" do
            node = ComparisonNode.new(
              op: operator,
              left: BooleanNode.new(value: left),
              right: BooleanNode.new(value: right),
            )

            expect(node.eval(environment)).to eq(Exceptional::Values::Boolean.new(value: result))
          end
        end
      end
    end

    pending "TypeError"
  end

  describe BooleanNode do
    let(:ast) do
      BooleanNode.new(value: true)
    end
    let(:environment) do
      Exceptional::Runtime::Environment.new(lexical_scope: parent_scope)
    end

    it "returns a Boolean value" do
      value = ast.eval(environment)
      expect(value).to eq(Exceptional::Values::Boolean.new(value: true))
    end
  end

  describe NumberNode do
    let(:ast) do
      NumberNode.new(value: 3)
    end
    let(:environment) do
      Exceptional::Runtime::Environment.new(lexical_scope: parent_scope)
    end

    it "returns a Number value" do
      value = ast.eval(environment)
      expect(value).to eq(Exceptional::Values::Number.new(value: 3))
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
        block_node: block
      )
    end
    let(:environment) do
      Exceptional::Runtime::Environment.new(lexical_scope: parent_scope)
    end

    it "creates a Proc that wraps the block and the lexical scope" do
      value = ast.eval(environment)
      expect(value).to be_a(Exceptional::Values::Proc)
      expect(value.param_list).to eq(["x"])

      block_value = value.block
      expect(block_value).to be_a(Exceptional::Values::Block)
      expect(block_value.block_node).to eq(block)
      expect(block_value.lexical_scope.parent_scope).to eq(parent_scope)
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
      Exceptional::Values::Proc.new(
        param_list: parameter_names,
        block_node: BlockNode.new(expressions: []),
        parent_scope: environment.lexical_scope,
      )
    end

    before do
      parent_scope.local_set("parent_variable", "something")
      parent_scope.local_set("hello", function)
    end

    it "creates a new stackframe" do
      expect(environment).to receive(:stack) { |scope| expect(scope.parent_scope).to eq(parent_scope) }
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

      it "fetches the parameters and calls the proc" do
        expect(function).to receive(:call).with(environment, ["something"])
        ast.eval(environment)
      end
    end

    context "when calling a non-proc" do
      pending "raises a TypeError"
    end
  end

  describe RescueNode do
    let(:environment) do
      Exceptional::Runtime::Environment.new(
        lexical_scope: parent_scope,
      )
    end
    let(:pattern_value) { double }
    let(:pattern) { double("Pattern", eval: pattern_value) }
    let(:block) { BlockNode.new(expressions: []) }
    let(:ast) do
      RescueNode.new(
        pattern: pattern,
        block_node: block,
      )
    end

    before { ast.eval(environment) }

    it "sets up a handler in the bottom-most stackframe" do
      handlers = environment.stackframes.last.exception_handlers
      expect(handlers.length).to eq(1)

      handler = handlers.first
      expect(handler.pattern).to eq(Exceptional::Values::Pattern.new(pattern: pattern_value))

      block_value = handler.block
      expect(block_value.block_node).to eq(block)
      expect(block_value.lexical_scope.parent_scope).to eq(parent_scope)
    end
  end

  describe RaiseNode do
    let(:environment) do
      Exceptional::Runtime::Environment.new(
        lexical_scope: parent_scope,
      )
    end
    let(:pattern) { Exceptional::Values::Pattern.new(pattern: double()) }
    let(:block) { BlockNode.new(expressions: []) }
    let(:ast) do
      RaiseNode.new(
        value: "a",
      )
    end

    context "with a handler on the current stackframe" do
      it "finds the handler, resets the stack, and resumes execution in the handler" do
        environment.stackframe.setup_handler(
          pattern: pattern,
          block_node: block,
          parent_scope: lexical_scope,
        )

        expect(pattern).to receive(:match?).with("a").and_return(true)
        expect(block).to receive(:eval).with(environment)
        ast.eval(environment)
      end
    end

    context "with a handler on a higher stackframe" do
      it "finds the handler, resets the stack, and resumes execution in the handler" do
        environment.stackframe.setup_handler(
          pattern: pattern,
          block_node: block,
          parent_scope: lexical_scope,
        )

        environment.stack(
          Exceptional::Runtime::LexicalScope.new(
            parent_scope: environment.lexical_scope,
          )
        )

        expect(pattern).to receive(:match?).with("a").and_return(true)
        expect {
          ast.eval(environment)
        }.to change { environment.stackframe }

        expect(environment.stackframe.lexical_scope.parent_scope).to eq(lexical_scope)
      end
    end

    context "without a handler" do
      it "doesn't raise the exception" do
        environment.stackframe.setup_handler(
          pattern: pattern,
          block_node: block,
          parent_scope: lexical_scope,
        )

        expect(pattern).to receive(:match?).with("a").and_return(false)
        expect(block).not_to receive(:eval).with(environment)
        ast.eval(environment)
      end
    end
  end

  describe HashNode do
    let(:ast) do
      HashNode.new(pair_list: [
        [StringNode.new(value: "a"), StringNode.new(value: "b")]
      ])
    end
    let(:environment) do
      Exceptional::Runtime::Environment.new(lexical_scope: parent_scope)
    end

    it "returns a HashMap value" do
      value = ast.eval(environment)
      expect(value).to eq(Exceptional::Values::HashMap.new(value: {
        Exceptional::Values::CharString.new(value: "a") => Exceptional::Values::CharString.new(value: "b")
      }))
    end
  end
end

describe Exceptional::Values do
  let(:parent_scope) do
    Exceptional::Runtime::LexicalScope.new(
      parent_scope: Exceptional::Runtime::LexicalScope::Null
    )
  end

  describe Exceptional::Values::Proc do
    let(:environment) do
      Exceptional::Runtime::Environment.new(
        lexical_scope: parent_scope,
      )
    end
    let(:function) do
      Exceptional::Values::Proc.new(
        param_list: ["x"],
        block_node: BlockNode.new(expressions: []),
        parent_scope: environment.lexical_scope,
      )
    end

    it "changes the lexical scope" do
      expect {
        function.call(environment, ["something"])
      }.to change { environment.lexical_scope }.from(parent_scope)
      expect(environment.lexical_scope.parent_scope).to eq(parent_scope)
    end

    it "creates a new stackframe" do
      expect {
        function.call(environment, ["something"])
      }.to change { environment.stackframes.length }.from(1).to(2)
    end

    it "creates local bindings for the parameters" do
      function.call(environment, ["something"])
      expect(environment.lexical_scope.get("x")).to eq("something")
    end
  end

  describe Exceptional::Values::Pattern do
    subject do
      described_class.new(
        pattern: Exceptional::Values::HashMap.new(
          value: {
            Exceptional::Values::CharString.new(value: "a") => Exceptional::Values::CharString.new(value: "b"),
            Exceptional::Values::CharString.new(value: "c") => Exceptional::Values::CharString.new(value: "d"),
          }
        )
      )
    end

    it "matches hashes of the same shape" do
      expect(subject).to match(subject.dup)
    end

    it "matches superset hashes" do
      superset = Exceptional::Values::HashMap.new(
        value: subject.pattern.value.merge(
          Exceptional::Values::CharString.new(value: "e") => Exceptional::Values::CharString.new(value: "f"),
        )
      )
      expect(subject.match?(superset)).to eq(true)
    end

    it "doesn't match subset hashes" do
      value = subject.pattern.value.dup
      value.delete(
        Exceptional::Values::CharString.new(value: "c")
      )
      subset = Exceptional::Values::HashMap.new(
        value: value
      )
      expect(subject.match?(subset)).to eq(false)
    end
  end
end

describe Exceptional::Runtime::LexicalScope do
  let(:subject) do
    described_class.new(parent_scope: described_class::Null)
  end

  before do
    subject.local_set("x", 1)
  end

  describe "#bindings" do
    it "returns the list of all bindings" do
      expect(subject.bindings).to eq({"x" => Exceptional::Runtime::ValueBinding.new(value: 1)})
    end

    context "with overridden bindings" do
      let(:subject) do
        described_class.new(parent_scope: super())
      end

      before do
        subject.local_set("x", 2)
        subject.local_set("y", 3)
      end

      it "returns the list of current bindings" do
        expect(subject.bindings).to eq({
          "x" => Exceptional::Runtime::ValueBinding.new(value: 2),
          "y" => Exceptional::Runtime::ValueBinding.new(value: 3),
        })
      end
    end
  end
end
