require "spec_helper"
require "tmpdir"

RSpec.describe "CLI" do
  let(:fs) { Armando::FileSystem::InMemory.new }

  def run(args=nil)
    executable = File.join(ROOT, "bin", "generator")
    system [executable, args, "--in-memory"].compact.join(" ")
  end

  xit "does something" do
    fs.dir.mktmpdir do |dir|
      content = <<~TEMPLATE
        create_file("my_file", "File Contents")
      TEMPLATE
      fs.file.write("/tmp/new_project.rb", content)

      run("new_project.rb")

      expect(fs.file.exist?("new_project.rb")).to eql(true)
      expect(fs.file.read("new_project.rb")).to eql(content)
    end
  end
end
