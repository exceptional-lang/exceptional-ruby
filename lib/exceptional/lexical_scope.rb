module Exceptional
  LexicalScope = Struct.new(:bindings, :parent_scope) do
    def initialize(parent_scope:)
      self.parent_scope = parent_scope
      self.bindings = {}
    end

    def get(binding_name)
      bindings[binding_name] || parent_scope.get(binding_name) # || raise
    end

    def local_set(binding_name, value)
      bindings[binding_name] = LocalBinding.new(value: value)
    end

    def set(binding_name, value)
      get(binding_name).value = value
    end
  end

  class LexicalScope
    module Null
      def self.get(binding)
        nil
      end
    end
  end

  LocalBinding = Struct.new(:value) do
    def initialize(value:)
      self.value = value
    end
  end
end
