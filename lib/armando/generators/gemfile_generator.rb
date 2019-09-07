module Armando
  class GemfileGenerator < Armando::Generator
    def generate!
      gems = arguments.map { |gem_key|
        gem(gem_key)
      }.join("\n")

      gems_string = if arguments.any?
                      "\n\n#{gems}"
                    else
                      ""
                    end

      gemfile_boilerplate = <<~EOF
       source "https://rubygems.org"#{gems_string}
      EOF

      File.write('Gemfile', gemfile_boilerplate.gsub(/\n\n\Z/, "\n"))
    end

    private

    def gem(gem_key)
      name, args = gem_key.split(':', 2)

      version, groups = args.to_s.split(':')

      args_str = gem_version(version)

      gem_groups(groups) do
        "gem #{gem_name(name)}#{args_str}"
      end
    end

    def gem_name(name)
      '"%s"' % name
    end

    def gem_version(version)
      return '' if version.to_s == ''

      ', "~> %s"' % version
    end

    def gem_groups(groups_str, &block)
      if groups_str
        <<~EOF
          group :#{groups_str} do
            #{block.call}
          end
        EOF
      else
        yield
      end
    end
  end
end
