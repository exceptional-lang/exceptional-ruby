module Exceptional
  module Ast
    AssignNode = Struct.new(:binding, :value) do
      def initialize(binding:, value:)
        @binding = binding
        @value = value
      end
    end
  end
end
