module Exceptional
  module Runtime
    Stackframe = Struct.new(:exception_handlers, :lexical_scope) do
      def initialize(lexical_scope:)
        self.exception_handlers = []
        self.lexical_scope = lexical_scope
      end

      def setup_handler(pattern:, block_node:, parent_scope:)
        handler = Exceptional::Values::ExceptionHandler.new(
          pattern: pattern,
          block_node: block_node,
          parent_scope: parent_scope,
          stackframe: self,
        )
        exception_handlers.push(handler)
        handler
      end
    end
  end
end
