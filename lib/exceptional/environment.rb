module Exceptional
  Environment = Struct.new(:stackframes, :lexical_scope) do
    def initialize(lexical_scope:)
      self.stackframes = []
      self.lexical_scope = lexical_scope
    end
  end
end
