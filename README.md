# Taopaipai

A dead-simple, dependency-less gem to control Raspberry GPIO pins using Linux User Space. No
root-access is required as Taopaipai handles pins reservation using the filsystem.

## Installation

Add this line to your application's Gemfile:

    gem 'taopaipai'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install taopaipai

## Usage

GPIO pins are exposed through the `Taopaipai.gpio` method :

```ruby
require 'taopaipai'

pin = Taopaipai.gpio.pin(17, direction: :out, value: 0)

# Write 1 to the pin 17
pin.value(1)

# Read from the pin 27
Taopaipai.gpio.pin(27, direction: :in).value
# => 0
```

Notice that Taopaipai memoizes the pin states so that it never writes again to a pin unless its
value or direction changed.

```ruby
# Writes for the first time
pin = Taopaipai.gpio.pin(17, direction: :out, value: 1)

# Does not write anything
1000.times do
  pin.value(1)
end

# Back to 0 !
pin(17).value(0)

# Change the pin's direction and read its value
pin.direction(:in).value
```

## Other useful projects

Taopaipai was meant to be the simplest approach to control GPIO using ruby code, without the need
for native extensions or FFI. If you need more powerful control over Raspberry Pi IO, you may have
a look at these useful projects:

* [WiringPi](https://github.com/WiringPi/WiringPi) (C/C++): Arduino wiring-like WiringPi
Library for the Raspberry Pi
* [WiringPi-Ruby](https://github.com/WiringPi/WiringPi-Ruby): Ruby wrapper around the WiringPi
library
* [PiPiper](https://github.com/jwhitehorn/pi_piper): Event driven Raspberry Pi GPIO programming in Ruby

## Contributing

1. Fork it ( http://github.com/servebox/taopaipai/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
