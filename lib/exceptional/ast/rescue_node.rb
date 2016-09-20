module Exceptional
  module Ast
    RescueNode = Struct.new(:pattern, :block_node) do
      def initialize(pattern:, block_node:)
        self.pattern = pattern
        self.block_node = block_node
      end

      def eval(environment)
        environment.stackframe.setup_handler(
          pattern: pattern.eval(environment),
          block_node: block_node,
          parent_scope: environment.lexical_scope,
        )
      end
    end
  end
end
