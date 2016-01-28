module Exceptional
  module Runtime
    LexicalScope = Struct.new(:bindings, :parent_scope) do
      def initialize(parent_scope:)
        self.parent_scope = parent_scope
        self.bindings = {}
      end

      def get(binding_name)
        local_binding = get_binding(binding_name)
        # || raise
        local_binding.value
      end

      def local_set(binding_name, value)
        bindings[binding_name] = LocalBinding.new(value: value)
      end

      def set(binding_name, value)
        local_binding = get_binding(binding_name)
        # raise
        local_binding.value = value
      end

      protected

      def get_binding(binding_name)
        bindings[binding_name] || parent_scope.get_binding(binding_name)
      end
    end

    class LexicalScope
      module Null
        def self.get(_)
          nil
        end

        def self.get_binding(_)
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
end
