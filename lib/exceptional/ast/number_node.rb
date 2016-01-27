module Exceptional
  module Ast
    NumberNode = Struct.new(:value) do
      def initialize(value:)
        self.value = value
      end
    end
  end
end
