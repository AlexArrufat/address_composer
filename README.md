# Address Composer

Based on an amazing work of [OpenCage Data](https://github.com/OpenCageData/address-formatting/)
who collected so many international formats of postal addresses, this is a Ruby implementation
of that formatter.

The goal of this gem is processing the output of [ruby_postal](https://github.com/openvenues/ruby_postal)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'address_composer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install address_composer

## Usage

```ruby
require "address_composer"

address_components = {
  "house_number" => 301,
  "road" => "Hamilton Avenue",
  "neighbourhood" => "Crescent Park",
  "city" => "Palo Alto",
  "postcode" => 94303,
  "county" => "Santa Clara County",
  "state" => "California",
  "country" => "United States of America",
  "country_code" => "US"
}

puts AddressComposer.compose(address_components)

301 Hamilton Avenue
Palo Alto, CA 94303
United States of America
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mirubiri/address_composer



Many thanks to these implementations:

- [Perl](https://github.com/OpenCageData/perl-Geo-Address-Formatter)
- [PHP](https://github.com/predicthq/address-formatter-php)
- [Javascript](https://github.com/fragaria/address-formatter)
- [Rust](https://github.com/CanalTP/address-formatter-rs)
