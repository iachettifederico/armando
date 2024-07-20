# frozen_string_literal: true

module Armando
  module FileSystem
    class InMemory
      class Dir
        def self.[](filesystem)
          new(filesystem: filesystem)
        end

        def initialize(filesystem:)
          @filesystem = filesystem
        end

        def pwd
          @filesystem.dir_pwd
        end

        def chdir(path, &block)
          @filesystem.dir_chdir(path, &block)
        end

        def mktmpdir(&block)
          tmpdir = "/tmp/rand"
          @filesystem.mkdir_p(tmpdir)
          chdir(tmpdir, &block)
        end
      end
    end
  end
end
