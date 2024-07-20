# frozen_string_literal: true

module Armando
  module FileSystem
    class InMemory
      class File
        def self.[](filesystem)
          new(filesystem: filesystem)
        end

        def initialize(filesystem:)
          @filesystem = filesystem
        end

        def read(path)
          @filesystem.file_read(path)
        end

        def write(path, content="")
          @filesystem.file_write(path, content)
        end

        def join(*path)
          ::File.join(*path)
        end

        def exist?(path)
          @filesystem.file_exist?(path)
        end
      end
    end
  end
end
