module Exceptional
  Stackframe = Struct.new(:handlers) do
    def initialize
      self.handlers = []
    end
  end
end
