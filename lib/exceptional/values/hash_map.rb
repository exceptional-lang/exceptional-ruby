module Exceptional
  module Values
    HashMap = Struct.new(:value) do
      def initialize(value:)
        self.value = value
      end
    end
  end
end
