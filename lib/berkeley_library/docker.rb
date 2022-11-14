require 'berkeley_library/docker/logging'
require 'berkeley_library/docker/module_info'
require 'berkeley_library/docker/secret'
require 'berkeley_library/docker/railtie' if defined?(Rails::Railtie)

module BerkeleyLibrary
  module Docker
    class << self
      def running_in_container?
        File.exist?('/.dockerenv') || init_cgroup_is_dockerish?
      end

      private

      def init_cgroup_is_dockerish?
        begin
          File.open('/proc/1/cgroup').read.match?(%r{(/docker|/lxc)})
        rescue
          false
        end
      end
    end
  end
end
