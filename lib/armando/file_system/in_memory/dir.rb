# frozen_string_literal: true

module Armando
  module FileSystem
    class InMemory
      class Dir
        def self.[](fs)
          new(fs: fs)
        end

        def initialize(fs:)
          @fs = fs
        end

        def pwd
          @fs.dir_pwd
        end

        def chdir(path, &block)
          @fs.dir_chdir(path, &block)
        end

        def mktmpdir(&block)
          dir_name = "rand"
          tmpdir = "/tmp/rand"
          @fs.mkdir_p(tmpdir)
          chdir(tmpdir, &block)
        end
      end
    end
  end
end
