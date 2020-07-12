
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nordvpn/api/version"

Gem::Specification.new do |spec|
  spec.name          = "nordvpn-api"
  spec.version       = Nordvpn::Api::VERSION
  spec.authors       = ["Sebastian Johnsson"]
  spec.email         = ["sebastian.johnsson@gmail.com"]

  spec.summary       = %q{NordVPN API Client in Ruby}
  spec.description   = %q{Ruby client to interact with NordVPN's API:s}
  spec.homepage      = "https://github.com/SebastianJ/nordvpn-api"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_dependency 'faraday', '~> 1.0', '>= 1.0.1'
  spec.add_dependency 'faraday_middleware', '~> 1.0'
  spec.add_dependency 'agents', '~> 0.1.4'

  spec.add_development_dependency 'bundler', '~> 2.1', '>= 2.1.4'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.1'
  spec.add_development_dependency 'rspec', '~> 3.9'
  
  spec.add_development_dependency 'pry', '~> 0.13.1'
end
