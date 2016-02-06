module Exceptional
  module Values
    ExceptionHandler = Struct.new(:pattern, :block) do
      def initialize(pattern:, block_node:, parent_scope:)
        self.pattern = pattern
        self.block = Exceptional::Values::Block.new(
          block_node: block_node,
          parent_scope: parent_scope,
        )
      end

      def match?(value)
        pattern.match?(value)
      end

      def call(environment, exception)
        block.call(environment)
      end
    end
  end
end
