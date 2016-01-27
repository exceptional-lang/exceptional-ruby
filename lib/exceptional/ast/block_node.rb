module Exceptional
  module Ast
    BlockNode = Struct.new(:expressions) do
      def initialize(expressions:)
        self.expressions = expressions
      end

      def eval(environment)
        expressions.each do |expression|
          expression.eval(environment)
        end
      end
    end
  end
end
