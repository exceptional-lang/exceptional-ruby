module Exceptional
  module Ast
    FunctionNode = Struct.new(:param_list, :block) do
      def initialize(param_list:, block:)
        self.param_list = param_list
        self.block = block
      end

      def eval(environment)
        Exceptional::Values::Lambda.new(
          param_list: param_list.binding_names,
          block: block,
          lexical_scope: Exceptional::Runtime::LexicalScope.new(
            parent_scope: environment.lexical_scope
          )
        )
      end
    end
  end
end
