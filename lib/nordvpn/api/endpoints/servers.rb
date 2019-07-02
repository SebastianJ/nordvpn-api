module Nordvpn
  module Api
    module Endpoints
      module Servers
        
        def retrieve_servers(memoize: true)
          servers     =   memoize ? self.cache.fetch("servers", nil) : nil
        
          if servers.nil?
            servers                 =   get("/server")&.body
            self.cache["servers"]   =   servers if memoize
          end

          return servers
        end
        
        def country_servers
          get("/v1/servers/countries")&.body
        end
      
        def ikev2_servers(servers: nil, memoize: true)
          servers_by_features(features: ["ikev2"], servers: servers, memoize: memoize)
        end
      
        def openvpn_tcp_servers(servers: nil, memoize: true)
          servers_by_features(features: ["openvpn_tcp"], servers: servers, memoize: memoize)
        end
      
        def openvpn_udp_servers(servers: nil, memoize: true)
          servers_by_features(features: ["openvpn_udp"], servers: servers, memoize: memoize)
        end
      
        def socks_servers(servers: nil, memoize: true)
          servers_by_features(features: ["socks"], servers: servers, memoize: memoize)
        end
      
        def proxy_servers(servers: nil, memoize: true)
          servers_by_features(features: ["proxy", "proxy_ssl"], servers: servers, memoize: memoize)
        end
      
        def pptp_servers(servers: nil, memoize: true)
          servers_by_features(features: ["pptp"], servers: servers, memoize: memoize)
        end
      
        def l2tp_servers(servers: nil, memoize: true)
          servers_by_features(features: ["l2tp"], servers: servers, memoize: memoize)
        end
      
        def servers_by_features(features: [], servers: nil, memoize: true)
          filtered          =   []
          
          servers           =   servers.nil? ? retrieve_servers(memoize: memoize) : servers
          
          servers&.each do |server|
            matching_all    =   true
          
            features.each do |feature|
              matching_all  =   matching_all && server.dig("features", feature).eql?(true)
              break if !matching_all
            end
          
            filtered       <<   server if matching_all
          end
        
          return filtered
        end
        
        def servers_by_country(country, servers: nil, memoize: true)
          servers           =   servers.nil? ? retrieve_servers(memoize: memoize) : servers
          filtered          =   servers&.select { |server| server["flag"].downcase.eql?(country.downcase) }
        end
        
        def servers_by_type_and_country(type, country, servers: nil, memoize: true)
          result            =   send("#{type}_servers", servers: servers, memoize: memoize)
          result            =   servers_by_country(country, servers: result, memoize: memoize)
        end
        
      end
    end
  end
end