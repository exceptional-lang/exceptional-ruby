module Exceptional
  module Ast
    CallNode = Struct.new(:expression, :param_list) do
      def initialize(expression:, param_list:)
        self.expression = expression
        self.param_list = param_list
      end
    end
  end
end
