require "spec_helper"

include ValuesHelper
describe Exceptional do
  context "simple case" do
    let(:code) {
      <<-SOURCE
      let a = ""
      let b = ""

      rescue({ x => y }) do
        a = x
        b = y
      end

      let fn = def(x) do
        raise({ "x" => x })
      end

      fn(3)
      SOURCE
    }

    let(:ast) { Exceptional.parse(code) }
    let(:env) { Exceptional.new_environment }

    it "works" do
      ast.eval(env)
      expect(env.lexical_scope.get("a")).to eq(v_char_string("x"))
      expect(env.lexical_scope.get("b")).to eq(v_number(3))
    end
  end

  context "fibonacci" do
    let(:code) {
      <<-SOURCE
        let fib = def(k) do
          rescue({ "m" => m, "k" => 0 }) do
            raise({ "result" => m })
          end
          rescue({ "m" => m, "n" => n, "k" => k }) do
            raise({ "m" => n, "n" => m + n, "k" => k - 1 })
          end

          raise({ "m" => 0, "n" => 1, "k" => k })
        end

        let res = ""
        let setup = def() do
          rescue({ "result" => r }) do
            res = r
          end
          fib(6)
        end
        setup()
      SOURCE
    }

    let(:ast) { Exceptional.parse(code) }
    let(:env) { Exceptional.new_environment }

    it "works" do
      ast.eval(env)
      expect(env.lexical_scope.get("res")).to eq(v_number(8))
    end
  end
end
