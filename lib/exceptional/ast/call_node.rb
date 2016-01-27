module Exceptional
  module Ast
    CallNode = Struct.new(:expression, :param_list) do
      def initialize(expression:, param_list:)
        @expression = expression
        @param_list = param_list
      end
    end
  end
end
