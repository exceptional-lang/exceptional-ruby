module Exceptional
  module Ast
    HashAccessNode = Struct.new(:receiver, :property) do
      def initialize(receiver:, property:)
        self.receiver = receiver
        self.property = property
      end

      def eval(environment)
        prop = property.eval(environment)
        # raise unless prop
        rec = receiver.eval(environment)
        # raise unless receiver
        rec.value[prop]
      end
    end
  end
end
