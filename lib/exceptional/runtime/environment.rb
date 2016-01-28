module Exceptional
  module Runtime
    Environment = Struct.new(:stackframes, :lexical_scope) do
      def initialize(lexical_scope:)
        self.stackframes = []
        self.lexical_scope = lexical_scope
        stack
      end

      def stack
        stackframes << Exceptional::Runtime::Stackframe.new
      end
    end
  end
end
