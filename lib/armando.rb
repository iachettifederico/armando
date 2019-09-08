require "armando/version"

require "armando/generators/generator"
require "armando/generators/file_generator"
require "armando/generators/gemfile_generator"

module Armando
  class Error < StandardError; end

  def self.for(generator_key, arguments)
    {
      'gemfile' => GemfileGenerator
    }[generator_key.downcase].new(arguments)
  end
end
