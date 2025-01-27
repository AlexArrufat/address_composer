lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "address_composer/version"

Gem::Specification.new do |gem|
  gem.name          = "address_composer"
  gem.version       = AddressComposer::VERSION
  gem.authors       = ["Alejandro Arrufat"]
  gem.email         = ["mirubiri@gmail.com"]

  gem.summary       = "Universal international address composer in Ruby"
  gem.description   = "Address Composer formats address components using worldwide regions formatting templates"
  gem.homepage      = "https://github.com/mirubiri/address_composer"
  gem.license       = "MIT"
  gem.metadata      = {
    "changelog_uri"     => "https://github.com/mirubiri/address_composer/CHANGELOG.md",
    "documentation_uri" => "https://github.com/mirubiri/address_composer/README.md",
    "homepage_uri"      => "https://github.com/mirubiri/address_composer",
    "source_code_uri"   => "https://github.com/mirubiri/address_composer"
  }

  gem.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files --recurse-submodules -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  end

  gem.required_ruby_version = ">= 2.6"
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency "mustache"
  
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rubocop"
  gem.add_development_dependency "ostruct"
  gem.add_development_dependency "reline"
  gem.add_development_dependency "irb"
  gem.add_development_dependency "fiddle"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
