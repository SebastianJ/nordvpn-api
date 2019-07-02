module Nordvpn
  module Api
    class Configuration
      attr_accessor :host, :faraday, :verbose
    
      def initialize
        self.host         =   "https://api.nordvpn.com"
        
        self.faraday      =   {adapter: :net_http}
        
        self.verbose      =   false
      end
    
    end
  end
end
