module Exceptional
  module Ast
    ComparisonNode = Struct.new(:op, :left, :right) do
      def initialize(op:, left:, right:)
        self.op = op
        self.left = left
        self.right = right
      end

      def eval(environment)
        left_value = left.eval(environment).value
        right_value = right.eval(environment).value
        Exceptional::Values::Boolean.new(value: left_value.send(op, right_value))
      end
    end
  end
end
