module Armando
  class FileGenerator < Armando::Generator
    def initialize(file_name, arguments=[])
      @file_name = file_name
      @indent_level = 0
      super(arguments)
    end

    def generate!
      File.write(file_name, render)
    end

    def render
      @_content = []

      content

      newline

      @_content.join("\n")
    end

    private

    attr_reader :file_name
    attr_reader :indent_level

    def text(str)
      str.split("\n").each do |line|
        @_content << indentation + line
      end
    end

    def line(str)
      @_content << indentation + str
    end

    def newline
      line ''
    end

    def block_maybe(condition, template=condition)
      if condition
        block(template) { yield }
      else
        yield
      end
    end

    def block(string)
      line(string + " do")
      inc_indent
      yield
      dec_indent
      line("end")
    end

    def indentation
      ' ' * (indent_level*2)
    end

    def last_line
      @_content.last
    end

    def last_lines(n=1)
      @_content.last(n)
    end

    def inc_indent
      @indent_level += 1
    end

    def dec_indent
      @indent_level -= 1
    end

  end
end
