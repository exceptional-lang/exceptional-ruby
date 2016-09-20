require "spec_helper"

include ValuesHelper
describe Exceptional do
  let(:code) {
    <<~SOURCE
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
