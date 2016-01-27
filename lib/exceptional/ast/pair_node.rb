module Exceptional
  module Ast
    PairNode = Struct.new(:binding_name, :value) do
      def initialize(binding_name:, value:)
        self.binding_name = binding_name
        self.value = value
      end
    end
  end
end
