module Exceptional
  LexicalScope = Struct.new(:bindings, :parent_scope) do
    module Null
      def local_get(binding)
        nil
      end
    end

    def initialize(parent_scope:)
      @parent_scope = parent_scope
      @bindings = {}
    end

    def local_get(binding)
      @binding[binding]
    end
  end
end
