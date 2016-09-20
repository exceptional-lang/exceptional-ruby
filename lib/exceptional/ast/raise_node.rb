module Exceptional
  module Ast
    RaiseNode = Struct.new(:value) do
      def initialize(value:)
        self.value = value
      end

      def eval(environment)
        bindings, handler = find_handler(environment)
        return unless handler
        environment.reset_frame(handler.stackframe)
        bindings.each do |binding_name, value|
          environment.lexical_scope.local_set(binding_name, value)
        end
        handler.call(environment, value)
      end

      private

      def find_handler(environment)
        raised_value = value.eval(environment)
        environment.stackframes.reverse.each do |frame|
          frame.exception_handlers.each do |handler|
            next [] unless bindings = handler.match(raised_value)
            return [bindings, handler]
          end
        end
        nil
      end
    end
  end
end
