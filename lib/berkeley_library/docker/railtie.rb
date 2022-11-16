require 'berkeley_library/docker/secret'

module BerkeleyLibrary
  module Docker
    class Railtie < ::Rails::Railtie
      include Logging

      def load_secrets!
        Secret.load_secrets!
      end

      private

      config.before_configuration { load_secrets! }

      # @note Logging occurs later because the Rails logger, which we use to
      # bootstrap ours, isn't initialized until after `before_configuration`.
      initializer 'berkeley_library-docker.log_loaded_secrets' do
        Secret.secrets.each do |_, secret|
          log_info "Loaded secret: #{secret.inspect}"
        end
      end
    end
  end
end
