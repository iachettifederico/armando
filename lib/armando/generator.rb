# frozen_string_literal: true

module Armando
  class Generator
    def initialize(base_directory: nil, fs: FileSystem::Real.new)
      @fs = fs
      @base_directory = base_directory || fs.dir.pwd
    end

    def self.run(&block)
      blocks << block
    end

    def self.blocks
      @blocks ||= []
    end

    def generate!
      self.class.blocks.each do |block|
        instance_eval(&block)
      end
    end

    private

    attr_reader :fs

    def create_directory(path)
      fs.fileutils.mkdir_p(fs.file.join(@base_directory, path))
    end

    def create_file(path, content="")
      *path_arr, file = path.split("/")
      create_directory(path_arr.join("/"))
      fs.file.write(fs.file.join(@base_directory, path), content)
    end

    def insert_text_after(text, after:, file:)
      original_content = fs.file.read(full_path(file))
      new_content = original_content[/(.*#{after})(.*)/, 1] + text + original_content[/(.*#{after})(.*)/, 2]

      fs.file.write(full_path(file), new_content)
    end

    def insert_text_before(text, before:, file:)
      original_content = fs.file.read(full_path(file))
      new_content = original_content[/(.*)(#{before}.*)/, 1] + text + original_content[/(.*)(#{before}.*)/, 2]

      fs.file.write(full_path(file), new_content)
    end

    def insert_text_between(text, file:, before:, after:)
      content = fs.file.read(full_path(file))

      content[/(#{after})(.*)(#{before})/, 2] = text

      fs.file.write(full_path(file), content)
    end

    def delete(path)
      fs.fileutils.rm_rf(fs.file.join(@base_directory, path))
    end

    def full_path(path)
      fs.file.join(@base_directory, path)
    end
  end
end
