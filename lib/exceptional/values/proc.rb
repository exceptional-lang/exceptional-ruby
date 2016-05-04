module Exceptional
  module Values
    Proc = Struct.new(:param_list, :block) do
      def initialize(param_list:, block_node:, parent_scope:)
        self.param_list = param_list
        self.block = Exceptional::Values::Block.new(
          block_node: block_node,
          parent_scope: parent_scope,
        )
      end

      def call(environment, arguments)
        environment.stack(block.lexical_scope)
        param_list.zip(arguments).each do |binding_name, value|
          environment.lexical_scope.local_set(binding_name, value)
        end
        block.call(environment)
      end
    end
  end
end
