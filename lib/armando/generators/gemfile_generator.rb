module Armando
  class GemfileGenerator < Armando::FileGenerator
    def initialize(arguments=[])
      super('Gemfile', arguments)
    end

    private

    def content
      source
      gems
    end

    def source
      line 'source "https://rubygems.org"'
    end

    def gems
      all_groups.each do |groups, gems|
        newline

        add_group groups do
          gems.sort.each do |gem|
            line GemGenerator.new(gem).render
          end
        end
      end
    end

    def add_group(groups)
      block_maybe(groups.any?, "group :#{groups.join(', :')}") {
        yield
      }
    end

    def all_groups
      arguments.group_by { |argument|
        argument.split(':')[1].to_s.split(',').sort
      }.to_a.sort_by { |groups, _|
        [groups.count, groups]
      }
    end

    class GemGenerator
      def initialize(input_string)
        @name    = input_string.split(':')[0]
        @version = generate_version(input_string.split(':')[2])
      end

      def render
        "gem \"#{name}\"#{version}"
      end

      private

      attr_reader :name
      attr_reader :version
      attr_reader :indent

      def generate_version(version_string)
        return '' if version_string.to_s == ''

        ", \"~> %s\"" % version_string
      end
    end
  end
end
