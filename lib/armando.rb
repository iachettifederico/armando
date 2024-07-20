# frozen_string_literal: true

require_relative "armando/version"

require "awesome_print"
AwesomePrint.defaults = {
  indent: 2,
  index:  false,
}

module Armando
  class Error < StandardError; end
  # Your code goes here...
end

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup
loader.eager_load
