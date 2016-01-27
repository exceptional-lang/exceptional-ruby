module Exceptional
  module Ast
    class AssignNode
      def initialize(binding:, value:)
        @binding = binding
        @value = value
      end
    end
  end
end
