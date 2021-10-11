require "address_composer/version"
require "yaml"
require "mustache"

class AddressComposer
  GEM_ROOT = Gem::Specification.find_by_name("address_composer").gem_dir
  Templates = YAML.load_file(File.join(GEM_ROOT, "address-formatting", "conf", "countries", "worldwide.yaml"))
  ComponentsList = Psych.load_stream(File.read(File.join(GEM_ROOT,"address-formatting", "conf","components.yaml")))
  AllComponents = ComponentsList.map { |h| h["name"] } + ComponentsList.flat_map { |h| h["aliases"] }.compact
  StateCodes = YAML.load_file(File.join(GEM_ROOT, "address-formatting", "conf", "state_codes.yaml"))
  CountyCodes = YAML.load_file(File.join(GEM_ROOT, "address-formatting", "conf", "county_codes.yaml"))

  class Template < Mustache
    def first
      lambda do |template|
        render(template.strip).split("||").map(&:strip).reject(&:empty?).first
      end
    end
  end

  def self.compose(components)
    new(components).compose
  end

  attr_accessor :components

  def initialize(components)
    self.components = components.dup

    normalize_components
  end

  def compose
    if components["country_code"]
      result = Template.render(template, components).squeeze("\n").lstrip.gsub(/\s*\n\s*/, "\n")
      result = post_format_replace(result)
    else
      result = components.values.join(" ")
    end

    # Remove duplicated spaces
    result = result.squeeze(" ")

    # Remove duplicated returns and add one at the end
    result = result.split("\n").uniq.join("\n") + "\n"

    # Remove spaces and commas before and after return
    result = result.gsub(/[,|\s]*\n[\s|,]*/, "\n")

    # Remove duplicated consecutive words
    result = result.gsub(/([[:alnum:]]+,)\s+\1/, '\1') # remove duplicates

    # Remove trailing non-word characters
    result.sub(/^[,|\s|-]*/, "")
  end

  private

  def template
    @template ||= if (components.keys & %w[road postcode]).empty?
                    formatting_rule["fallback_template"] || Templates["default"]["fallback_template"]
                  else
                    formatting_rule["address_template"]
                  end
  end

  def formatting_rule
    formatting_rules.last
  end

  def country_code
    @country_code || components["country_code"]
  end

  def formatting_rules
    return @formatting_rules if @formatting_rules

    initial_rule = Templates[country_code]

    if initial_rule
      fallback_rule = Templates[initial_rule["use_country"]]
    else
      initial_rule = Templates["default"]
    end

    @formatting_rules = [initial_rule, fallback_rule].compact
  end

  def normalize_components
    components.transform_values!(&:to_s)
    components["country_code"] = components["country_code"].to_s.upcase

    fix_countries
    fix_states
    apply_formatting_rules
    apply_aliases
    normalize_aliases
  end

  def fix_countries
    if components["country_code"] == "NL" && components["state"]
      if components["state"] == "Curaçao"
        components["country_code"] = "CW"
        components["country"] = "Curaçao"
      elsif components["state"].match?(/sint maarten/i)
        components["country_code"] = "SX"
        components["country"] = "Sint Maarten"
      elsif components["state"].match?(/aruba/i)
        components["country_code"] = "AW"
        components["country"] = "Aruba"
      end
    end
  end

  def fix_states
    if components["state"]&.match?(/^washington,? d\.?c\.?/i)
      components["state_code"] = "DC"
      components["state"] = "District of Columbia"
      components["city"] = "Washington"
    end
  end

  def apply_formatting_rules
    formatting_rules.each do |rule|
      new_component = rule["add_component"]
      use_country = rule["use_country"]
      change_country = rule["change_country"]
      replaces = rule["replace"]

      if use_country
        @use_country = use_country
        components["country_code"] = @use_country
      end

      if change_country
        components["country"] = change_country.gsub(/\$state/, components["state"].to_s)
      end

      if replaces
        replace(replaces)
      end

      if new_component
        components.store(*new_component.split("="))
      end
    end
  end

  def apply_aliases
    components.keys.each do |key|
      component = ComponentsList.detect { |member| member["aliases"].to_a.include?(key) }
      components[component["name"]] ||= components[key] if component
    end

    unknown_components = components.keys - AllComponents

    components["attention"] = unknown_components.map do |unknown|
      components.delete(unknown)
    end.join(" ")
  end

  def normalize_aliases
    state_group = [components["state"], components["state_code"]].compact
    state_code, state = StateCodes[@use_country || components["country_code"].upcase]&.select { |k, v| ([k, v] & state_group).any? }.to_a.flatten
    components["state_code"] = state_code unless state_code.nil?
    components["state"] = state unless state.nil?

    county_group = [components["county"], components["county_code"]].compact
    county_code, county = CountyCodes[components["country_code"].upcase]&.select { |k, v| ([k, v] & county_group).any? }.to_a.flatten
    components["county"] = county unless county.nil?
    components["county_code"] = county_code unless county_code.nil?

    if components["postcode"]&.include?(";")
      components.delete("postcode")
    end

    if components["postcode"]&.include?(",")
      components["postcode"] = components["postcode"].split(",").first
    end

    # Clean values with "", nil or []
    self.components = components.reject { |_, v| v.nil? || v.empty? }

    # If country is a number use the state as country
    if components["country"]&.match?(/^\d+$/)
      components["country"] = components["state"]
    end

    # Remove components with URL
    components.delete_if { |_, v| v.match?(URI::DEFAULT_PARSER.make_regexp) }
  end

  def replace(replaces)
    replaces.each do |rule|
      from, to = rule
      to = to.tr("$", "\\") # FIX: Solo numeros $1, $2...

      if from.match?(/^.*=/)
        attr, value = from.split("=")
        components[attr] = components[attr]&.gsub(/#{value}/, to)
      else
        components.keys.each do |key|
          components[key] = components[key]&.gsub(Regexp.new(from), to)
        end
      end
    end
  end

  def post_format_replace(string)
    return string unless formatting_rule["postformat_replace"]

    formatting_rule["postformat_replace"].each do |rule|
      from = rule.first
      to = rule.last.tr("$", "\\")
      string = string.gsub(/#{from}/, to)
    end

    string
  end
end
