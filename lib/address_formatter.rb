require "address_formatter/version"

require "zeitwerk"
require "mustache"
require "YAML"
Zeitwerk::Loader.for_gem.setup

class AddressFormatter
  class Error < StandardError; end

  Templates = YAML.load_file(File.join("address-formatting/conf/countries/worldwide.yaml"))

  attr_accessor :components

  def self.format(components)
    new.format(components)
  end

  def format(components)
    self.components = components
    Mustache.render(address_template, components)
  end

  private

  def address_template
    country_config["address_template"] || country_config["use_country"]
  end

  def country_config
    Templates[components["country_code"].upcase]
  end
end
