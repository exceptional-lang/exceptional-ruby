module Exceptional
  module Ast
    ParamListNode = Struct.new(:binding_names) do
      def initialize(binding_names:)
        self.binding_names = binding_names
      end
    end
  end
end
