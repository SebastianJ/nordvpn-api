require "faraday"
require "faraday_middleware"
require "agents"
require "logger"

require "nordvpn/api/version"
require "nordvpn/api/configuration"

require "nordvpn/api/endpoints/servers"
require "nordvpn/api/client"

module Nordvpn
  module Api
    
    class << self
      attr_writer :configuration
    
      def configuration
        @configuration ||= ::Nordvpn::Api::Configuration.new
      end

      def reset
        @configuration = ::Nordvpn::Api::Configuration.new
      end

      def configure
        yield(configuration)
      end
    end
    
    class Error < StandardError; end
  end
end
