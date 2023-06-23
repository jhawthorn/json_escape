# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

if RUBY_ENGINE == "jruby"
  task default: %i[test]
else
  require "rake/extensiontask"

  Rake::ExtensionTask.new("json_escape") do |ext|
    ext.lib_dir = "lib/json_escape"
  end

  task default: %i[clobber compile test]
end
