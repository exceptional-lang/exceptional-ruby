module Exceptional
  module Ast
    NumberNode = Struct.new(:value) do
      def initialize(value:)
        self.value = value
      end

      def eval(environment)
        Exceptional::Values::Number.new(value: value)
      end
    end
  end
end
