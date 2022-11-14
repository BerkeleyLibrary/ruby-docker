require 'berkeley_library/docker/secret'
require 'fileutils'
require 'spec_helper'

module BerkeleyLibrary
  module Docker
    describe Secret do
      it 'loads secrets into the environment' do
        with_secret('DB_PASSWORD', 'f00BarbAz') do
          expect(ENV['DB_PASSWORD']).to be nil
          Secret.load_secrets!
          expect(ENV['DB_PASSWORD']).to eq 'f00BarbAz'
        end
      end

      it 'reads multiline secrets' do
        with_secret('SSH_PRIVATE_KEY', "d33db55f\nd33db55f") do
          expect(ENV['SSH_PRIVATE_KEY']).to be nil
          Secret.load_secrets!
          expect(ENV['SSH_PRIVATE_KEY']).to eq "d33db55f\nd33db55f"
        end
      end

      it 'strips trailing whitespace' do
        with_secret('API_TOKEN', "d33db55f\n") do
          expect(ENV['API_TOKEN']).to be nil
          Secret.load_secrets!
          expect(ENV['API_TOKEN']).to eq 'd33db55f'
        end
      end

      it 'ignores subdirectories in the secrets directory' do
        FileUtils.mkdir_p(File.join(SPEC_SECRETS_PATH, 'some-dir'))
        expect{ Secret.load_secrets! }.not_to raise_error
      end

      it 'searches ENV["UCBLIB_SECRETS_PATH"] by default' do
        with_secret('MASTER_KEY', 'd33db55f', '/tmp/super-secrets') do
          Secret.load_secrets!
          expect(ENV['MASTER_KEY']).to be nil

          ENV['UCBLIB_SECRETS_PATH'] = '/tmp/super-secrets'

          Secret.load_secrets!
          expect(ENV['MASTER_KEY']).to eq 'd33db55f'
        end
      end
    end
  end
end
