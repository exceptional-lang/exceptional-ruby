module Exceptional
  module Ast
    class FunctionNode
      def initialize(param_list:, block:)
        @param_list = param_list
        @block = block
      end
    end
  end
end
