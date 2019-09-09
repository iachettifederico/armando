require "armando/version"

require "armando/generators/generator"
require "armando/generators/file_generator"
require "armando/generators/template_generator"
require "armando/generators/gemfile_generator"

module Armando
  class Error < StandardError; end

  def self.for(generator_key, arguments, configuration)
    generator_name = generator_key.downcase
    {
      'gemfile' => GemfileGenerator,
    }.fetch(generator_name) {
      TemplateGenerator[generator_name, configuration]
    }.new(arguments)
  end
end
