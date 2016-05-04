module Exceptional
  module Values
    Block = Struct.new(:block_node, :lexical_scope) do
      def initialize(block_node:, parent_scope:)
        self.block_node = block_node
        self.lexical_scope = Exceptional::Runtime::LexicalScope.new(
          parent_scope: parent_scope,
        )
      end

      def call(environment)
        block_node.eval(environment)
      end
    end
  end
end
