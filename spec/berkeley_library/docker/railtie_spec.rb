require 'spec_helper'
require 'rails'
require 'berkeley_library/docker/railtie'
require 'logger'

module BerkeleyLibrary
  module Docker
    describe Railtie do
      # @note Simply defining the app class causes railtie
      # `before_configuration` blocks to run, and we only get to define one
      # application, hence this one test needs to handle everything.
      it 'causes rails to load the environment' do
        with_secret('FOOBAR', 'BAZ') do
          with_secret('CLIENT_KEY', 'd33db55f') do
            logger = spy Logger.new(STDOUT)

            expect(ENV['CLIENT_KEY']).to be nil

            # Use Class.new so that `logger` is within scope
            @klass = Class.new(Rails::Application) do
              Rails.logger = logger
              config.client_key = ENV['CLIENT_KEY']
            end

            expect(ENV['CLIENT_KEY']).to eq 'd33db55f'

            app = @klass.create
            app.initialize!

            expect(app.config.client_key).to eq 'd33db55f'
            expect(logger).to have_received(:info).twice.with(/Loaded secret:.*/)
          end
        end
      end
    end
  end
end
