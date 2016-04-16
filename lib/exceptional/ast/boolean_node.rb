module Exceptional
  module Ast
    BooleanNode = Struct.new(:value) do
      def initialize(value:)
        self.value = value
      end

      def eval(environment)
        Exceptional::Values::Boolean.new(value: value)
      end
    end
  end
end
