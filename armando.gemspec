# frozen_string_literal: true

require_relative "lib/armando/version"

Gem::Specification.new do |spec|
  spec.name = "armando"
  spec.version = Armando::VERSION
  spec.authors = ["Federico Iachetti"]
  spec.email = ["iachetti.federico@gmail.com"]

  spec.summary = "Code Generator"
  spec.description = "A simple code generator"
  spec.homepage = "https://rubygems.org/gems/example"

  spec.licenses    = ["MIT"]

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "https://github.com/example/example"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "awesome_print", "~> 1.9.2"
  spec.add_dependency "zeitwerk", "~> 2.6.16"
end
