# frozen_string_literal: false

# TODO: Make ^true and fix errors

module Armando
  class Generator
    def initialize(base_directory: nil, filesystem: FileSystem::Real.new)
      @filesystem = filesystem
      @base_directory = base_directory || filesystem.dir.pwd
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

    attr_reader :filesystem

    def create_directory(path)
      filesystem.fileutils.mkdir_p(filesystem.file.join(@base_directory, path))
    end

    def create_file(path, content="")
      *path_arr, _file = path.split("/")
      create_directory(path_arr.join("/"))
      filesystem.file.write(filesystem.file.join(@base_directory, path), content)
    end

    def insert_text_after(text, after:, file:)
      original_content = filesystem.file.read(full_path(file))
      new_content = original_content[/(.*#{after})(.*)/, 1] + text + original_content[/(.*#{after})(.*)/, 2]

      filesystem.file.write(full_path(file), new_content)
    end

    def insert_text_before(text, before:, file:)
      original_content = filesystem.file.read(full_path(file))
      new_content = original_content[/(.*)(#{before}.*)/, 1] + text + original_content[/(.*)(#{before}.*)/, 2]

      filesystem.file.write(full_path(file), new_content)
    end

    def insert_text_between(text, file:, before:, after:)
      content = filesystem.file.read(full_path(file))

      content[/(#{after})(.*)(#{before})/, 2] = text

      filesystem.file.write(full_path(file), content)
    end

    def delete(path)
      filesystem.fileutils.rm_rf(filesystem.file.join(@base_directory, path))
    end

    def full_path(path)
      filesystem.file.join(@base_directory, path)
    end
  end
end
