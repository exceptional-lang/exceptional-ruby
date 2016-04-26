module Exceptional
  module Ast
    CallNode = Struct.new(:expression, :param_list) do
      def initialize(expression:, param_list:)
        self.expression = expression
        self.param_list = param_list
      end

      def eval(environment)
        function = expression.eval(environment)
        # raise unless function.is_a?(Exceptional::Values::Lambda)
        arguments = param_list.map { |exp| exp.eval(environment) }
        function.call(environment, arguments)
      end
    end
  end
end
