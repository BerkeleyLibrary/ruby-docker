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

      it 'has the expected initializer name' do
        expect(railtie_name).to eq 'berkeley_library-docker.load_secrets'
      end

      it 'causes rails to load the environment' do
        with_secret('API_TOKEN', 'd33db55f') do
          app = TestApp.create
          expect(ENV['API_TOKEN']).to be nil

          app.initialize!
          expect(ENV['API_TOKEN']).to eq 'd33db55f'
        end
      end

      it 'loads after the logger and before configuration' do
        railtie_index = initializers.find_index(railtie_name)
        logger_index = initializers.find_index(:initialize_logger)
        config_index = initializers.find_index(:load_config_initializers)

        expect(railtie_index).to be_between(logger_index, config_index)
      end
    end
  end
end
