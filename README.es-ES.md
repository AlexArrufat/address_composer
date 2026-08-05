

# Address Composer

Basado en el increíble trabajo de [OpenCage Data](https://github.com/OpenCageData/address-formatting/)
quien recopiló tantos formatos internacionales de direcciones postales, esta es una implementación en Ruby
de ese formateador.

El objetivo de esta gema es procesar la salida de [ruby_postal](https://github.com/openvenues/ruby_postal)

## Instalación

Agrega esta línea al Gemfile de tu aplicación:

```ruby
gem 'address_composer'
```

Y luego ejecuta:

    $ bundle

O instálalo tú mismo como:

    $ gem install address_composer

## Uso

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

También puedes controlar si la salida debe abreviarse o no pasando `should_abbreviate`:

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
  "country_code" => "US",
  "should_abbreviate" => true
}

puts AddressComposer.compose(address_components)

301 Hamilton Ave
Palo Alto, CA 94303
United States of America

```

## Desarrollo

Después de clonar el repositorio, ejecuta `git submodule init` y `git submodule update` para obtener todos los datos del proyecto del submódulo y revisar el commit mapeado.

Luego, ejecuta `bin/setup` para instalar las dependencias. Después, ejecuta `rake spec` para correr las pruebas. También puedes ejecutar `bin/console` para obtener un prompt interactivo que te permitirá experimentar.

Para instalar esta gema en tu máquina local, ejecuta `bundle exec rake install`. Para publicar una nueva versión, actualiza el número de versión en `version.rb` y luego ejecuta `bundle exec rake release`, lo cual creará una etiqueta git para la versión, enviará los commits y etiquetas de git, y subirá el archivo `.gem` a [rubygems.org](https://rubygems.org).

## Contribuir

Los informes de errores y pull requests son bienvenidos en GitHub en https://github.com/mirubiri/address_composer



Muchas gracias a estas implementaciones:

- [Perl](https://github.com/OpenCageData/perl-Geo-Address-Formatter)
- [PHP](https://github.com/predicthq/address-formatter-php)
- [Javascript](https://github.com/fragaria/address-formatter)
- [Rust](https://github.com/CanalTP/address-formatter-rs)
