# frozen_string_literal: true

module Armando
  module FileSystem
    class InMemory
      class FileUtils
        def self.[](filesystem)
          new(filesystem: filesystem)
        end

        def initialize(filesystem:)
          @filesystem = filesystem
        end

        def mkdir_p(path)
          @filesystem.mkdir_p(path)
        end

        def rm_rf(path)
          @filesystem.rm_rf(path)
        end
      end
    end
  end
end
