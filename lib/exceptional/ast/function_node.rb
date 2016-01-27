module Exceptional
  module Ast
    FunctionNode = Struct.new(:param_list, :block) do
      def initialize(param_list:, block:)
        self.param_list = param_list
        self.block = block
      end
    end
  end
end
