require 'berkeley_library/docker/secret'

module BerkeleyLibrary
  module Docker
    class Railtie < Rails::Railtie
      config.before_configuration { Secret.load_secrets! }
    end
  end
end
