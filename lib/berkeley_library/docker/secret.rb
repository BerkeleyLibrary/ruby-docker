require 'berkeley_library/docker/logging'

module BerkeleyLibrary
  module Docker
    class Secret
      class << self
        include Logging

        PATH_OVERRIDE_ENVVAR = 'UCBLIB_SECRETS_PATH'
        DEFAULT_SECRETS_PATH = '/run/secrets'

        def load_secrets!(glob = nil)
          files_from(glob).each(&method(:load_secret!))
        end

        private

        def load_secret!(filepath)
          secret = File.basename(filepath)
          ENV[secret] = File.read(filepath).strip
          log_info "Loaded secret `ENV['#{secret}']` from #{filepath}"
        end

        def files_from(glob = nil)
          glob ||= ENV[PATH_OVERRIDE_ENVVAR] || DEFAULT_SECRETS_PATH
          glob = glob.strip

          if File.directory?(glob) && !glob.end_with?('*')
            glob = File.join(glob, '*')
          end

          log_info "Searching '#{glob}' for secrets files"
          Dir[glob].filter_map { |fname| fname if File.file? fname }
        end
      end
    end
  end
end
