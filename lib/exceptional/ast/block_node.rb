module Exceptional
  module Ast
    BlockNode = Struct.new(:expressions) do
      def initialize(expressions:)
        @expressions = expressions
      end
    end
  end
end
