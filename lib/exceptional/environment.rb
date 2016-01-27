module Exceptional
  Environment = Struct.new(:stackframes) do
    def initialize
      self.stackframes = []
    end

    def get(name)
    end

    def set(name, value)
    end

    def local_set(name, value)
    end
  end
end
