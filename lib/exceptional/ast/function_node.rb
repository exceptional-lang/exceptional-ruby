module Exceptional
  module Ast
    FunctionNode = Struct.new(:param_list, :block_node) do
      def initialize(param_list:, block_node:)
        self.param_list = param_list
        self.block_node = block_node
      end

      def eval(environment)
        Exceptional::Values::Proc.new(
          param_list: param_list.binding_names,
          block_node: block_node,
          parent_scope: environment.lexical_scope,
        )
      end
    end
  end
end
