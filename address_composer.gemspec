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
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  end

  gem.required_ruby_version = ">= 2.4"
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "mustache", "~> 1.1"

  gem.add_development_dependency "bundler", "~> 1.17"
  gem.add_development_dependency "pry", "~> 0.13"
  gem.add_development_dependency "pry-byebug", "~> 3.9"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "~> 3.0"
end
