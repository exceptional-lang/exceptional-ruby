module Exceptional
  module Ast
    NumberNode = Struct.new(:value) do
      def initialize(value:)
        @value = value
      end
    end
  end
end
