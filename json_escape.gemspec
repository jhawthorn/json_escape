# frozen_string_literal: true

require_relative "lib/json_escape/version"

Gem::Specification.new do |spec|
  spec.name = "json_escape"
  spec.version = JsonEscape::VERSION
  spec.authors = ["John Hawthorn"]
  spec.email = ["john@hawthorn.email"]

  spec.summary = "JSON escape"
  spec.description = "JSON escape"
  spec.homepage = "https://github.com/jhawthorn/json_escape"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if RUBY_ENGINE == 'jruby'
    spec.platform = 'java'
  else
    spec.extensions = ["ext/json_escape/extconf.rb"]
  end

  spec.add_development_dependency "rake-compiler"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "benchmark-ips"
  spec.add_development_dependency "json"
end
