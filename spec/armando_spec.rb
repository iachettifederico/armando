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
    system "../bin/armando #{args.join(' ')}"
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
