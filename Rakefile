require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

SCANNER_SOURCE_FILE_NAME = "lib/exceptional/exceptional.rex"
SCANNER_FILE_NAME = "lib/exceptional/scanner.rb"

PARSER_SOURCE_FILE_NAME = "lib/exceptional/exceptional.y"
PARSER_FILE_NAME = "lib/exceptional/generated_parser.rb"

file(SCANNER_FILE_NAME => [SCANNER_SOURCE_FILE_NAME]) do
  sh("rex", SCANNER_SOURCE_FILE_NAME, "-o", SCANNER_FILE_NAME)
end

file(PARSER_FILE_NAME => [PARSER_SOURCE_FILE_NAME]) do
  sh("racc", PARSER_SOURCE_FILE_NAME, "-o", PARSER_FILE_NAME)
end

task(spec: [SCANNER_FILE_NAME, PARSER_FILE_NAME])
task(default: [:spec])
