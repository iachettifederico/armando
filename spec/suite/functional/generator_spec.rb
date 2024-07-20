# frozen_string_literal: true

require "spec_helper"

require "pathname"

RSpec.describe "XXX spec" do
  let(:root_dir) { Pathname.new(__dir__ + "/../../..").expand_path }
  let(:base_dir) { "#{root_dir}/tmp" }

  let(:fs) { Armando::FileSystem::InMemory.new }

  def new_generator(&block)
    Class.new(Armando::Generator, &block)
         .new(base_directory: base_dir, fs: fs)
  end

  def read(path)
    fs.file.read(path)
  end

  def join(*path)
    fs.file.join(*path)
  end

  def exist?(*path)
    fs.file.exist?(*path)
  end

  it "can create a directory under the project root" do
    generator = new_generator {
      run do
        create_directory("new_directory/new_subdirectory")
      end
    }

    generator.generate!

    expect(exist?(join(base_dir, "new_directory", "new_subdirectory"))).to eql(true)
  end

  it "can create a file under the project root" do
    generator = new_generator {
      run do
        create_file("code.rb", "THE FILE CONTENTS")
        create_file("empty")
      end
    }

    generator.generate!

    expect(exist?(join(base_dir, "code.rb"))).to eql(true)
    expect(read(join(base_dir, "code.rb"))).to eql("THE FILE CONTENTS")

    expect(exist?(join(base_dir, "empty"))).to eql(true)
    expect(read(join(base_dir, "empty"))).to eql("")
  end

  it "can create a file under a non-existing directory" do
    generator = new_generator {
      run do
        create_file("a/non/existing/directory/pepe.rb", "THIS IS THE CONTENT")
      end
    }

    generator.generate!

    expect(exist?(join(base_dir, "a/non/existing/directory"))).to eql(true)
    expect(exist?(join(base_dir, "a/non/existing/directory", "pepe.rb"))).to eql(true)
    expect(read(join(base_dir, "a/non/existing/directory", "pepe.rb"))).to eql("THIS IS THE CONTENT")
  end

  it "can have multiple run blocks" do
    generator = new_generator {
      run do
        create_file("a/non/existing/directory/one.rb", "First block")
      end

      run do
        create_file("a/non/existing/directory/two.rb", "Second block")
      end
    }

    generator.generate!

    expect(exist?(join(base_dir, "a/non/existing/directory", "one.rb"))).to eql(true)
    expect(exist?(join(base_dir, "a/non/existing/directory", "two.rb"))).to eql(true)
  end

  it "multiple run blocks run in order" do
    generator = new_generator {
      def spy!
        @spies ||= []
        @spies << Time.now
      end

      def spies
        @spies
      end

      run do
        spy!
      end

      run do
        spy!
      end
    }

    generator.generate!

    expect(generator.spies.last).to be > generator.spies.first
  end

  it "can delete a file" do
    generator = new_generator {
      run do
        create_file("my_dir/my_file", "THIS FILE WILL BE DESTROYED")
      end

      run do
        delete("my_dir/my_file")
      end
    }

    generator.generate!

    expect(exist?(join(base_dir, "my_dir/my_file"))).to eql(false)
  end

  describe "inserting text" do
    it "can add a text after a string" do
      generator = new_generator {
        run do
          content = "1 3"
          create_file("my_file", content)
        end

        run do
          insert_text_after("2 ", after: "1 ", file: "my_file")
        end
      }

      generator.generate!

      expected_text = "1 2 3"

      expect(read(join(base_dir, "my_file"))).to eql("1 2 3")
    end

    it "can add a text before a string" do
      generator = new_generator {
        run do
          content = "a c"
          create_file("my_file", content)
        end

        run do
          insert_text_before("b ", before: "c", file: "my_file")
        end
      }

      generator.generate!

      expected_text = "a b c"

      expect(read(join(base_dir, "my_file"))).to eql(expected_text)
    end

    it "can have after and before at the same time" do
      generator = new_generator {
        run do
          create_file("abc", "alphabet")
          insert_text_between("*", file: "abc", after: "a", before: "t")
        end
      }

      generator.generate!

      expect(read(join(base_dir, "abc"))).to eql("a*t")
    end

    it "accepts a regex for the after" do
      generator = new_generator {
        run do
          content = "Add text after this awesome symbol *, but not after that"
          create_file("my_file", content)
        end

        run do
          insert_text_after(". Done", after: /this \w+ symbol \*/, file: "my_file")
        end
      }

      generator.generate!

      expect(read(join(base_dir, "my_file"))).to eql("Add text after this awesome symbol *. Done, but not after that")
    end

    it "accepts a regex for the before" do
      generator = new_generator {
        run do
          content = "Add text before THIS awesome symbol"
          create_file("my_file", content)
        end

        run do
          insert_text_before("HERE ", before: /THIS \w+ symbol/, file: "my_file")
        end
      }

      generator.generate!

      expect(read(join(base_dir, "my_file"))).to eql("Add text before HERE THIS awesome symbol")
    end

    it "accepts a regex for the after and the before" do
      generator = new_generator {
        run do
          content = "Add text between this symbol & and #"
          create_file("my_file", content)
        end

        run do
          insert_text_between("HERE", file: "my_file", after: /this symbol &/, before: /\#/)
        end
      }

      generator.generate!

      expect(read(join(base_dir, "my_file"))).to eql("Add text between this symbol &HERE#")
    end
  end
end
