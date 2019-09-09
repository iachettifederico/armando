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

    it "populates the Gemfile with some boilerplate" do
      content = GemfileGenerator.new.render

      expected = <<~EOF
        source "https://rubygems.org"
      EOF

      expect(content).to eql(expected)
    end

    it "populates the Gemfile with one gem" do
      content = GemfileGenerator.new('awesome_print').render

      expected = <<~EOF
        source "https://rubygems.org"

        gem "awesome_print"
      EOF

      expect(content).to eql(expected)
    end

    it "populates the Gemfile with multiple gems" do
      content = GemfileGenerator.new(['awesome_print', 'roda']).render

      expected = <<~EOF
        source "https://rubygems.org"

        gem "awesome_print"
        gem "roda"
      EOF

      expect(content).to eql(expected)
    end

    it "allows adding a version" do
      content = GemfileGenerator.new(['awesome_print::0.1.2']).render

      expected = <<~EOF
        source "https://rubygems.org"

        gem "awesome_print", "~> 0.1.2"
      EOF

      expect(content).to eql(expected)
    end

    it "allows adding a group" do
      content = GemfileGenerator.new(['awesome_print:development']).render

      expected = <<~EOF
        source "https://rubygems.org"

        group :development do
          gem "awesome_print"
        end
      EOF

      expect(content).to eql(expected)
    end

    it "allows adding multiple one gem groups" do
      content = GemfileGenerator.new([
                                       'awesome_print:development',
                                       'table_print:staging',
                                     ]).render

      expected = <<~EOF
        source "https://rubygems.org"

        group :development do
          gem "awesome_print"
        end

        group :staging do
          gem "table_print"
        end
      EOF

      expect(content).to eql(expected)
    end


    it "allows adding multiple gems to a group" do
      content = GemfileGenerator.new([
                                       'awesome_print:development',
                                       'table_print:development',
                                     ]).render

      expected = <<~EOF
        source "https://rubygems.org"

        group :development do
          gem "awesome_print"
          gem "table_print"
        end
      EOF

      expect(content).to eql(expected)
    end

    it "allows adding a gem to multiple groups" do
      content = GemfileGenerator.new([
                                       'awesome_print:development,production',
                                     ]).render

      expected = <<~EOF
        source "https://rubygems.org"

        group :development, :production do
          gem "awesome_print"
        end
      EOF

      expect(content).to eql(expected)
    end

    it "populates the Gemfile" do
      content = GemfileGenerator.new([
                                       'awesome_print:development,test:1.2.3',
                                       'rom::5.6.7',
                                       'rspec:test',
                                       'table_print:development,test',
                                       'rom-sqlite:development',
                                       'roda',
                                       'dotenv:development,staging',
                                     ]).render

      expected = <<~EOF
        source "https://rubygems.org"

        gem "roda"
        gem "rom", "~> 5.6.7"

        group :development do
          gem "rom-sqlite"
        end

        group :test do
          gem "rspec"
        end

        group :development, :staging do
          gem "dotenv"
        end

        group :development, :test do
          gem "awesome_print", "~> 1.2.3"
          gem "table_print"
        end
      EOF
      
      expect(content).to eql(expected)
    end
  end
end
