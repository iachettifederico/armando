module Armando
  module FileSystem
    class InMemory
      attr_reader :fs

      def initialize
        @fs = {}
      end

      def file
        File[self]
      end

      def dir
        Dir[self]
      end

      def fileutils
        FileUtils[self]
      end

      # File
      def file_read(path)
        fs.dig(*path.split("/")).string
      end

      def file_write(path, content)
        *path_arr, file = path.split("/")
        fs.dig(*path_arr)[file] = StringIO.new(content)
      end

      def file_exist?(path)
        !! fs.dig(*path.split("/"))
      end

      # Dir
      def dir_pwd
        @dir_pwd ||= "/"
      end

      def dir_chdir(path, &block)
        if block_given?
          old_pwd = @dir_pwd
          @dir_pwd = path
          block.call
          @dir_pwd = old_pwd
        else
          @dir_pwd = path
        end
      end

      # Fileutils
      def mkdir_p(path)
        path.split("/").inject(fs) do |fs, current_dir|
          fs[current_dir] ||= {}
        end
      end

      def rm_rf(path)
        *path_arr, last = path.split("/")
        fs.dig(*path_arr).delete(last)
      end
    end
  end
end
