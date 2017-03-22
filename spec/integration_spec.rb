require "spec_helper"

include ValuesHelper
describe Exceptional do
  let(:ast) { Exceptional.parse(code) }
  let(:env) { Exceptional.new_environment }

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

    it "works" do
      ast.eval(env)
      expect(env.lexical_scope.get("a")).to eq(v_char_string("x"))
      expect(env.lexical_scope.get("b")).to eq(v_number(3))
    end
  end

  context "fibonacci" do
    let(:code) {
      <<-source
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
      source
    }

    it "works" do
      ast.eval(env)
      expect(env.lexical_scope.get("res")).to eq(v_number(8))
    end
  end

  context "io" do
    describe "read" do
      let(:code) {
        <<-source
          let io = import("io")
          let content = {}
          rescue({ "io" => file }) do
            content = file
          end
          io.read("toto.txt")
        source
      }

      it "works" do
        allow(File).to receive(:read).and_call_original
        allow(File).to receive(:read)
          .with("toto.txt")
          .and_return("file content")
        ast.eval(env)
        binding.pry
        expect(env.lexical_scope.get("content")).to eq(v_char_string("file content"))
      end
    end
  end
end
