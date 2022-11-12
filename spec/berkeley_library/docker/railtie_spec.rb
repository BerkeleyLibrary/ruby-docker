require 'rails' # require Rails first to mimic load order
require 'berkeley_library/docker/railtie'
require 'spec_helper'

module BerkeleyLibrary
  module Docker
    describe Railtie do
      before do
        expect(ENV['API_TOKEN']).to be nil
      end

      it 'causes rails to load the environment' do
        with_secret('API_TOKEN', 'd33db55f') do
          class TestApp < Rails::Application; end
          TestApp.create.initialize!

          expect(ENV['API_TOKEN']).to eq 'd33db55f'
        end
      end
    end
  end
end
