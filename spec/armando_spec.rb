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

  it "creates a Gemfile" do
    armando 'Gemfile'

    expect(File.exist?('Gemfile')).to eql(true)
  end

  it "populates the Gemfile with some boilerplate" do
    armando 'Gemfile'

    expected = <<~EOF
      source "https://rubygems.org"
    EOF

    expect(File.read('Gemfile')).to eql(expected)
  end

  it "populates the Gemfile with one gem" do
    armando 'Gemfile awesome_print'

    expected = <<~EOF
      source "https://rubygems.org"

      gem "awesome_print"
    EOF

    expect(File.read('Gemfile')).to eql(expected)
    
  end
end
