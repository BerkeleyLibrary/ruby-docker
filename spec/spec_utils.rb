require 'berkeley_library/docker/secret'
require 'fileutils'

module SpecUtils
  def rollback_environment(&block)
    ENV.to_h.tap do |old_env|
      begin
        yield
      ensure
        ENV.replace(old_env)
      end
    end
  end

  def with_secret(secret_name, value, secrets_dir = nil, &block)
    rollback_environment do
      filepath = File.join(secrets_dir || SPEC_SECRETS_PATH, secret_name)
      FileUtils.mkdir_p(File.dirname(filepath))
      File.open(filepath, 'w+') { |fh| fh.puts value }

      begin
        yield
      ensure
        File.delete filepath
      end
    end
  end
end
