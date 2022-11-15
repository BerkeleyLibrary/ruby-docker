require 'rails' # require Rails first to mimic load order
require 'berkeley_library/docker/railtie'
require 'spec_helper'

module BerkeleyLibrary
  module Docker
    describe Railtie do
      class TestApp < Rails::Application; end

      let(:app) { TestApp.create }
      let(:initializers) { app.initializers.tsort_each.collect(&:name) }
      let(:railtie_name) { BerkeleyLibrary::Docker::Railtie::NAME }

      it 'causes rails to load the environment' do
        with_secret('API_TOKEN', 'd33db55f') do
          # @todo There is a very odd RSpec bug that causes the change{}
          # assertion to fail unless it's preceded by this nil assertion.
          expect(true).to be true

          expect { app.initialize! }
            .to change { ENV['API_TOKEN'] }
            .from(nil).to('d33db55f')
        end
      end

      it 'has the expected initializer name' do
        expect(railtie_name).to eq 'berkeley_library-docker.load_secrets'
      end

      it 'loads after the logger and before configuration' do
        railtie = initializers.find_index(railtie_name)
        logger = initializers.find_index(:initialize_logger)
        config = initializers.find_index(:load_config_initializers)

        expect(railtie).to be_between(logger, config)
      end
    end
  end
end
