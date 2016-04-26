module Exceptional
  module Runtime
    Environment = Struct.new(:stackframes, :lexical_scope) do
      def initialize(lexical_scope:)
        self.stackframes = []
        self.lexical_scope = lexical_scope
        stack
      end

      def stackframe
        stackframes.last
      end

      def stack
        stackframes << Exceptional::Runtime::Stackframe.new
      end

      def reset_frame(stackframe)
        self.stackframes = stackframes.take(stackframes.index(stackframe) + 1)
      end
    end
  end
end
