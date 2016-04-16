module Exceptional
  module Values
    Boolean = Struct.new(:value) do
      def initialize(value:)
        self.value = !!value
      end
    end
  end
end
