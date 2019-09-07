module Armando
  class Generator
    def initialize(arguments=[])
      @arguments = Array(arguments)
    end

    def generate!
    end

    private

    attr_reader :arguments
  end
end
