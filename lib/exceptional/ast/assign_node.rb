module Exceptional
  module Ast
    AssignNode = Struct.new(:binding_name, :value) do
      def initialize(binding_name:, value:)
        self.binding_name = binding_name
        self.value = value
      end

      def eval(environment)
        environment.set(binding_name.name, value.eval(environment))
      end
    end
  end
end
