module Exceptional
  module Ast
    RaiseNode = Struct.new(:value) do
      def initialize(value:)
        @value = value
      end
    end
  end
end
