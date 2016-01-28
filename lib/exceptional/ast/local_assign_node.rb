module Exceptional
  module Ast
    LocalAssignNode = Struct.new(:binding_name, :value) do
      def initialize(binding_name:, value:)
        self.binding_name = binding_name
        self.value = value
      end

      def eval(environment)
        environment.lexical_scope.local_set(binding_name.name, value.eval(environment))
      end
    end
  end
end
