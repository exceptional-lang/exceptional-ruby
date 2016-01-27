module Exceptional
  module Ast
    RaiseNode = Struct.new(:value) do
      def initialize(value:)
        self.value = value
      end
    end
  end
end
