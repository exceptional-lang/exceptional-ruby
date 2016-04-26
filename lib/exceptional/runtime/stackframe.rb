module Exceptional
  module Runtime
    Stackframe = Struct.new(:exception_handlers) do
      def initialize
        self.exception_handlers = []
      end

      def setup_handler(pattern:, block_node:, parent_scope:)
        exception_handlers.push(
          Exceptional::Values::ExceptionHandler.new(
            pattern: pattern,
            block_node: block_node,
            parent_scope: parent_scope,
            stackframe: self,
          )
        )
      end
    end
  end
end
