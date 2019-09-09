require "erb"

module Armando
  class TemplateGenerator < FileGenerator
    def self.[](template, configuration)
      Class.new(self).tap { |generator_class|
        generator_class.template      = template
        generator_class.configuration = configuration
      }
    end

    def self.template=(value)
      @template = value
    end

    def self.template
      @template
    end

    def self.configuration=(value)
      @configuration = value
    end

    def self.configuration
      @configuration
    end

    def initialize(arguments)
      @file_name     = arguments.shift

      super(file_name, arguments)

      @variables     = get_variables(arguments)
    end

    private
    attr_reader :variables

    def content
      text ERB.new(template, nil, '<>').result(binding)
    end

    def template
      File.read(template_file)
    end

    def template_file
      File.join(
        self.class.configuration.fetch('TEMPLATES_DIR'),
        self.class.template,
      )
    end

    def get_variables(args)
      args.each_with_object({}) { |str, hash|
        key, value = str.split('=')
        hash[key.to_sym] = value
      }
    end

    def method_missing(method_name, **args)
      variables.fetch(method_name) { super }
    end
  end
end
