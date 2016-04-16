module Exceptional
  module Ast
    StringNode = Struct.new(:value) do
      def initialize(value:)
        self.value = value
      end

      def eval(_)
        Exceptional::Values::CharString.new(value: value)
      end
    end
  end
end
