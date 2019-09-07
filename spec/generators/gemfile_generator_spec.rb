require 'spec_helper'

module Armando
  RSpec.describe GemfileGenerator do
    include FakeFS::SpecHelpers

    before do
      FakeFS.activate!
    end

    after do
      FakeFS.deactivate!
    end

    it "creates a Gemfile" do
      GemfileGenerator.new.generate!

      expect(File.exist?('Gemfile')).to eql(true)
    end

    it "populates the Gemfile with some boilerplate" do
      GemfileGenerator.new.generate!

      expected = <<~EOF
        source "https://rubygems.org"
      EOF

      expect(File.read('Gemfile')).to eql(expected)
    end

    it "populates the Gemfile with one gem" do
      GemfileGenerator.new('awesome_print').generate!

      expected = <<~EOF
        source "https://rubygems.org"

        gem "awesome_print"
      EOF

      expect(File.read('Gemfile')).to eql(expected)
    end

    it "populates the Gemfile with multiple gems" do
      GemfileGenerator.new(['awesome_print', 'roda']).generate!

      expected = <<~EOF
        source "https://rubygems.org"

        gem "awesome_print"
        gem "roda"
      EOF

      expect(File.read('Gemfile')).to eql(expected)
    end

    it "allows adding a version" do
      GemfileGenerator.new(['awesome_print:0.1.2']).generate!

      expected = <<~EOF
        source "https://rubygems.org"

        gem "awesome_print", "~> 0.1.2"
      EOF

      expect(File.read('Gemfile')).to eql(expected)
    end

    it "allows adding a environment" do
      GemfileGenerator.new(['awesome_print::development']).generate!

      expected = <<~EOF
        source "https://rubygems.org"

        group :development do
          gem "awesome_print"
        end
      EOF

      expect(File.read('Gemfile')).to eql(expected)
    end

  end
end
