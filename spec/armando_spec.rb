require 'fileutils'

RSpec.describe Armando do
  before do
    @current_dir = Dir.pwd
    Dir.chdir("tmp")
  end

  after do
    Dir.chdir("tmp") do
      system "rm -rf *"
    end
  end

  after do
    Dir.chdir(@current_dir)
  end

  def armando(*args)
    `../bin/armando #{args.join(' ')}`
  end

  context "Gemfile" do
    it "creates a Gemfile" do
      armando 'Gemfile'

      expect(File.exist?('Gemfile')).to eql(true)
    end

    it "populates the Gemfile" do
      armando 'gemfile awesome_print:development,test:1.2.3 rom::5.6.7 rspec:test table_print:development,test "rom-sqlite:development" roda dotenv:development,staging'

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

      expect(File.read('Gemfile')).to eql(expected)
    end
  end

  context "templates" do
    let(:templates_dir) { '/tmp/TD' }

    it "has a templates directory" do
      current_home = ENV.fetch('HOME')

      vars = armando "--variables"

      expect(vars).to include("TEMPLATES_DIR: #{current_home}/ArmandoTemplates")
    end

    it "allows the user to set a custom templates dir" do
      vars = armando "--variables --var TEMPLATES_DIR=/tmp/TD"

      expect(vars).to include("TEMPLATES_DIR: /tmp/TD")
    end

    it "creates a file from a template" do
      FileUtils.mkdir_p templates_dir
      
      template = <<~TEMPLATE
        This is a template. Magic Number: <%= magic_number %>
      TEMPLATE

      File.write(File.join(templates_dir, 'test_template'), template)
      
      armando "test_template /tmp/my_file magic_number=5 --var TEMPLATES_DIR=#{templates_dir}"
      
      expected = <<~TEMPLATE
        This is a template. Magic Number: 5
      TEMPLATE
      
      expect(File.read('/tmp/my_file')).to eql(expected)
    end
  end

  xcontext "gem" do
    # existing Gemfile
    # non-existent Gemfile
    # existing gem
    # non-existent gem
    xit "adds a gem to the Gemfile" do
      armando 'gemfile'

      armando 'gem my_gem --version 1.2.3 --path ../my_gem --groups development,test'

      expected = <<~EOF
      source "https://rubygems.org"

      group :development, :test do
        gem "my_gem", "~> 1.2.3", path: "../my_gem"
      end
    EOF

      expect(File.read('Gemfile')).to eql(expected)
    end
  end

end
