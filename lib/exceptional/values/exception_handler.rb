module Exceptional
  module Values
    ExceptionHandler = Struct.new(:pattern, :block, :stackframe) do
      def initialize(pattern:, block_node:, parent_scope:, stackframe:)
        self.pattern = pattern
        self.block = Exceptional::Values::Block.new(
          block_node: block_node,
          parent_scope: parent_scope,
        )
        self.stackframe = stackframe
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
