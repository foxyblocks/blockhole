require "bundler/gem_tasks"

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false

  # we require spec_helper so we don't get an RSpec warning about
  # examples being defined before configuration.
  # t.ruby_opts = "-w -I./spec -r./spec/capture_warnings -rspec_helper"
  t.rspec_opts = %w[--format progress]
end
