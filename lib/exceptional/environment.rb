module Exceptional
  Environment = Struct.new(:stackframes) do
    def initialize
      self.stackframes = []
    end

    def stackframe
      stackframes.last
    end

    def get(name)
      @stackframe.lexical_scope.get(name)
    end

    def set(name, value)
      @stackframe.lexical_scope.set(name)
    end

    def local_set(name, value)
    end
  end
end
