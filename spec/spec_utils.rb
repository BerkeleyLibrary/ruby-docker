require 'berkeley_library/docker/secret'
require 'fileutils'

module SpecUtils
  def rollback_environment(&block)
    old_envvars = ENV.keys

    begin
      yield
    ensure
      ENV.select! { |k, _| old_envvars.include? k }
    end
  end

  def with_secret(secret_name, value, &block)
    rollback_environment do
      filepath = File.join(SPEC_SECRETS_PATH, secret_name)
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
