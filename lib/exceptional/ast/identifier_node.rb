module Exceptional
  module Ast
    IdentifierNode = Struct.new(:name) do
      def initialize(name:)
        self.name = name
      end

      def eval(environment)
        environment.lexical_scope.get(name)
      end
    end
  end
end
