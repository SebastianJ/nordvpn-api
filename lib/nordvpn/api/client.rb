module Nordvpn
  module Api
    class Client
      attr_accessor :proxy, :configuration, :cache
    
      def initialize(proxy: nil, configuration: ::Nordvpn::Api.configuration)
        self.proxy            =   proxy
        self.configuration    =   configuration
        self.cache            =   {}
      end
    
      def connect(host:, options: {})
        request_options       =   options.fetch(:request, {})
        
        connection            =   ::Faraday.new(host, request: request_options) do |builder|
          builder.options[:timeout]         =   options.fetch(:timeout, nil)      if options.fetch(:timeout, nil)
          builder.options[:open_timeout]    =   options.fetch(:open_timeout, nil) if options.fetch(:open_timeout, nil)
        
          builder.request  :json
    
          builder.response :logger, ::Logger.new(STDOUT), bodies: true if self.configuration.verbose
          builder.response :json, content_type: /\bjson$/
    
          builder.use ::FaradayMiddleware::FollowRedirects, limit: 10
    
          if self.proxy
            builder.proxy     =   generate_proxy(self.proxy)
            puts "[NordVpn::Api::Client] - Will connect to NordVPN's API using proxy: #{self.proxy.inspect}" if self.configuration.verbose
          end

          builder.adapter self.configuration.faraday.fetch(:adapter, ::Faraday.default_adapter)
        end
      end

      def get(path, parameters: {}, headers: {}, options: {})
        request path, method: :get, parameters: parameters, headers: headers, options: options
      end
    
      def head(path, parameters: {}, headers: {}, options: {})
        request path, method: :head, parameters: parameters, headers: headers, options: options
      end

      def post(path, parameters: {}, data: {}, headers: {}, options: {})
        request path, method: :post, parameters: parameters, data: data, headers: headers, options: options
      end
    
      def put(path, parameters: {}, data: {}, headers: {}, options: {})
        request path, method: :put, parameters: parameters, data: data, headers: headers, options: options
      end
    
      def patch(path, parameters: {}, data: {}, headers: {}, options: {})
        request path, method: :patch, parameters: parameters, data: data, headers: headers, options: options
      end
    
      def delete(path, parameters: {}, data: {}, headers: {}, options: {})
        request path, method: :delete, parameters: parameters, data: data, headers: headers, options: options
      end
    
      def request(path, method: :get, parameters: {}, data: {}, headers: {}, options: {})
        connection                =   connect(host: self.configuration.host, options: options)
        
        headers["User-Agent"]     =   headers.fetch("User-Agent", ::Agents.random_user_agent(:desktop))
        
        response                  =   case method
          when :get
            connection.get do |request|
              request.url path unless path.to_s.empty?
              request.headers     =   connection.headers.merge(headers)
              request.params      =   parameters if parameters && !parameters.empty?
            end
          when :head
            connection.head do |request|
              request.url path unless path.to_s.empty?
              request.headers     =   connection.headers.merge(headers)
              request.params      =   parameters if parameters && !parameters.empty?
            end
          when :post, :put, :patch, :delete
            connection.send(method) do |request|
              request.url path unless path.to_s.empty?
              request.headers     =   connection.headers.merge(headers)
              request.body        =   data if data && !data.empty?
              request.params      =   parameters if parameters && !parameters.empty?
            end
        end
      end
      
      def generate_proxy(host:, port:, username:, password:)
        {
          uri:      "http://#{host}:#{port}",
          user:     username,
          password: password
        }
      end
      
      include ::Nordvpn::Api::Endpoints::Servers
          
    end
  end
end
