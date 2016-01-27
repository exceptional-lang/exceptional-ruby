module Exceptional
  module Ast
    StringNode = Struct.new(:value) do
      def initialize(value:)
        self.value = value
      end

      def eval(_)
        value
      end
    end
  end
end
