# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/extensiontask"

task build: :compile

Rake::ExtensionTask.new("json_escape") do |ext|
  ext.lib_dir = "lib/json_escape"
end

task default: %i[clobber compile]
