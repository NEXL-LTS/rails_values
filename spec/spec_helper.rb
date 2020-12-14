require 'bundler/setup'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.minimum_coverage_by_file 75
  SimpleCov.minimum_coverage 88
  SimpleCov.start
end

require 'active_job'
require 'rails_values'

class SimpleModel
  include ActiveModel::Model

  attr_accessor :name
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
