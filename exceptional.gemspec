# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exceptional/version'

Gem::Specification.new do |spec|
  spec.name          = "exceptional"
  spec.version       = Exceptional::VERSION
  spec.authors       = ["Guillaume Malette"]
  spec.email         = ["guillaume@jadedpixel.com"]

  spec.summary       = %q{Exceptional is an exception-based language}
  spec.description   = %q{Exceptional is an exception-based language}
  spec.homepage      = "https://github.com/exceptional-lang/exceptional"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-mocks"
  spec.add_development_dependency "rexical", "~> 1.0"
  spec.add_development_dependency "racc", "~> 1.4"
  spec.add_development_dependency "pry-byebug"
end
