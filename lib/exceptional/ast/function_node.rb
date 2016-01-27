module Exceptional
  module Ast
    FunctionNode = Struct.new(:param_list, :block) do
      def initialize(param_list:, block:)
        @param_list = param_list
        @block = block
      end
    end
  end
end
