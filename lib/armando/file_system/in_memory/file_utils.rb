module Armando
  module FileSystem
    class InMemory
      class FileUtils
        def self.[](fs)
          new(fs: fs)
        end

        def initialize(fs:)
          @fs = fs
        end

        def mkdir_p(path)
          @fs.mkdir_p(path)
        end

        def rm_rf(path)
          @fs.rm_rf(path)
        end
      end
    end
  end
end
