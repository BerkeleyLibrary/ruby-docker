require 'berkeley_library/docker/secret'
require 'fileutils'
require 'spec_helper'

module BerkeleyLibrary
  module Docker
    describe Secret do
      it 'loads secrets into the environment' do
        with_secret('DB_PASSWORD', 'f00BarbAz') do
          expect { Secret.load_secrets! }
            .to change { ENV['DB_PASSWORD'] }
            .from(nil).to('f00BarbAz')
        end
      end

      it 'reads multiline secrets' do
        with_secret('SSH_PRIVATE_KEY', "d33db55f\nd33db55f") do
          expect { Secret.load_secrets! }
            .to change { ENV['SSH_PRIVATE_KEY'] }
            .from(nil).to("d33db55f\nd33db55f")
        end
      end

      it 'strips trailing whitespace' do
        with_secret('API_TOKEN', "d33db55f\n") do
          expect { Secret.load_secrets! }
            .to change { ENV['API_TOKEN'] }
            .from(nil).to('d33db55f')
        end
      end

      it 'ignores subdirectories in the secrets directory' do
        FileUtils.mkdir_p(File.join(SPEC_SECRETS_PATH, 'some-dir'))
        expect { Secret.load_secrets! }.not_to raise_error
        expect { Secret.load_secrets! }.not_to change { ENV }
      end

      it 'searches ENV["UCBLIB_SECRETS_PATH"] by default' do
        secrets_subdir = File.join(SPEC_SECRETS_PATH, 'super-secrets')

        with_secret('MASTER_KEY', 'd33db55f', secrets_subdir) do
          expect { Secret.load_secrets! }.not_to change { ENV }

          ENV['UCBLIB_SECRETS_PATH'] = secrets_subdir

          expect { Secret.load_secrets! }
            .to change { ENV['MASTER_KEY'] }
            .from(nil).to('d33db55f')
        end
      end
    end
  end
end
