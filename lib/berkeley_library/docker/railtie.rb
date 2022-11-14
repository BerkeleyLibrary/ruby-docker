require 'berkeley_library/docker/secret'

module BerkeleyLibrary
  module Docker
    class Railtie < Rails::Railtie
      NAME = 'berkeley_library-docker.load_secrets'.freeze

      initializer(NAME, after: :initialize_logger) { Secret.load_secrets! }
    end
  end
end
