module Exceptional
  module Runtime
    Environment = Struct.new(:stackframes, :lexical_scope) do
      def initialize(lexical_scope:)
        self.stackframes = []
        stack(lexical_scope)
      end

      def stackframe
        stackframes.last
      end

      def stack(lexical_scope)
        stackframe = Exceptional::Runtime::Stackframe.new(lexical_scope: lexical_scope)
        stackframes << stackframe
        stackframe
      end

      def lexical_scope
        stackframe.lexical_scope
      end

      def reset_frame(stackframe)
        self.stackframes = stackframes.take(stackframes.index(stackframe) + 1)
      end
    end
  end
end
