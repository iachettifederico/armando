ENV["ENVIRONMENT"] = "test"

if ENV["COVERAGE"] == "true"
  puts "Running specs with coverage"
  require 'simplecov'
  SimpleCov.start
end

require "./lib/armando"

RSpec.configure do |config|
  config.order = :random
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
