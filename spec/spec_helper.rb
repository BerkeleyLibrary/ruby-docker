require_relative './spec_utils.rb'

# Avoid issues with `/run` being read-only on MacOS
SPEC_SECRETS_PATH = ENV['UCBLIB_SECRETS_PATH'] = '/tmp/secrets'

RSpec.configure do |config|
  config.include SpecUtils

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
