module Exceptional
  module Values
    Number = Struct.new(:value) do
      def initialize(value:)
        self.value = value.to_r
      end
    end
  end
end
