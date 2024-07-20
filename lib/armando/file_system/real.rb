# frozen_string_literal: true

require "fileutils"

module Armando
  module FileSystem
    class Real
      def file
        ::File
      end

      def dir
        ::Dir
      end

      def fileutils
        ::FileUtils
      end
    end
  end
end
