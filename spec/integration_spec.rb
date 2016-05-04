require "spec_helper"

describe Exceptional do
  let(:code) {
    <<~SOURCE
      let a = ""

      rescue({ "x" => 1 }) do
        a = 1
      end

      let fn = def(x) do
        raise({ "x" => x })
      end

      fn(1)
    SOURCE
  }

  let(:ast) { Exceptional.parse(code) }
  let(:env) { Exceptional.new_environment }

  it "works" do
    ast.eval(env)
    expect(env.lexical_scope.get("a")).to eq(Exceptional::Values::Number.new(value: 1))
  end
end
