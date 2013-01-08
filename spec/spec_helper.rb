require 'pry-nav'
require 'support/credentials'
require 'support/logger_helper'
require 'fex'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = false
  config.order = 'random'

  config.include LoggerHelper

  if Credentials.all.has_key?("production")
    config.include Credentials::Keys,       :production_environment
    config.include Credentials::Production, :production_environment
  else
    config.filter_run_excluding :production_environment
  end

  if Credentials.all.has_key?("test")
    config.include Credentials::Keys, :test_environment
    config.include Credentials::Test, :test_environment
  else
    config.filter_run_excluding :test_environment
  end
end
