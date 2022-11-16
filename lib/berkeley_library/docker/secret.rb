require 'berkeley_library/docker/logging'
require 'digest'
require 'time'

module BerkeleyLibrary
  module Docker
    class Secret
      class << self
        include Logging

        PATH_OVERRIDE_ENVVAR = 'UCBLIB_SECRETS_PATTERN'
        DEFAULT_SECRETS_PATTERN = '/run/secrets/*'

        def load_secrets!(glob = nil, reload = false)
          glob = normalize_glob(glob)

          secrets.merge!(
            files_from(glob).each_with_object({}) do |path, new_secrets|
              secret_name = File.basename(path)
              secret_value = File.read(path).strip

              ENV[secret_name] = secret_value

              new_secrets[secret_name] = {
                name: secret_name,
                file: path,
                checksum: "sha256:#{Digest::SHA256.hexdigest(secret_value)}",
                glob: glob,
                timestamp: Time.now.to_i,
              }
            end
          )
        end

        def secrets
          @secrets ||= {}
        end

        private

        def files_from(glob)
          Dir[glob].filter_map { |fname| fname if File.file? fname }
        end

        def normalize_glob(glob)
          (glob || ENV[PATH_OVERRIDE_ENVVAR] || DEFAULT_SECRETS_PATTERN)
            .then(&:strip)
            .then(&method(:ensure_dir_asterisk))
        end

        def ensure_dir_asterisk(glob)
          if !glob.end_with?('*') && File.directory?(glob)
            File.join(glob, '*')
          else
            glob
          end
        end
      end
    end
  end
end
