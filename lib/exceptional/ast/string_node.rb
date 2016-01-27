module Exceptional
  module Ast
    StringNode = Struct.new(:value) do
      def initialize(value:)
        @value = value
      end
    end
  end
end
