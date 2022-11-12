require 'forwardable'
require 'logger'

module BerkeleyLibrary
  module Docker
    module Logging
      extend Forwardable

      def logger
        @logger ||= begin
          if defined?(Rails) && Rails.logger
            Rails.logger
          else
            Logger.new(STDOUT)
          end
        end
      end

      # Prefixed "log_" to avoid conflicts with core methods,
      # namely 'warn'.
      [:debug, :info, :warn, :error, :fatal].each do |level|
        def_delegator :logger, level, :"log_#{level}"
      end
    end
  end
end
