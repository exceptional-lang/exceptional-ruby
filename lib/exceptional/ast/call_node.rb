module Exceptional
  module Ast
    class CallNode
      def initialize(expression:, param_list:)
        @expression = expression
        @param_list = param_list
      end
    end
  end
end
