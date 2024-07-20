# frozen_string_literal: true

module Armando
  module FileSystem
    class InMemory
      class File
        def self.[](fs)
          new(fs: fs)
        end

        def initialize(fs:)
          @fs = fs
        end

        def read(path)
          @fs.file_read(path)
        end

        def write(path, content="")
          @fs.file_write(path, content)
        end

        def join(*path)
          ::File.join(*path)
        end

        def exist?(path)
          @fs.file_exist?(path)
        end
      end
    end
  end
end
