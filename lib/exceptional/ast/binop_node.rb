module Exceptional
  module Ast
    BinopNode = Struct.new(:op, :left, :right) do
      def initialize(op:, left:, right:)
        self.op = op
        self.left = left
        self.right = right
      end

      def eval(environment)
        left_value = left.eval(environment)
        right_value = right.eval(environment)
        raise "unhandled" unless right_value.class == left_value.class
        left_value.class.new(value: left_value.value.send(op, right_value.value))
      end
    end
  end
end
