module Exceptional
  module Runtime
    NativeFunction = Struct.new(:block) do
      def initialize(block:)
        self.block = block
      end

      def call(environment, arguments)
        environment.stack(
          Exceptional::Runtime::LexicalScope.new(
            parent_scope: Exceptional::Runtime::LexicalScope::Null,
          )
        )
        block.call(environment, arguments)
      end
    end
  end
end
