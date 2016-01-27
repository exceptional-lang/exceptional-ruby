module Exceptional
  module Ast
    class PairNode
      def initialize(binding:, value:)
        @binding = binding
        @value = value
      end
    end
  end
end
