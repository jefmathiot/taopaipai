module Taopaipai
  class GPIO

    BASE_PATH = '/sys/class/gpio'

    def initialize
      @io = IO.new(BASE_PATH)
      @registry = {}
    end

    def pin(number, options={})
      pin = @registry[pin_key(number)]
      if pin
        [:direction, :value].each do |option|
          pin.send option, options[option] if options.has_key?(option)
        end
        pin
      else
        @registry[pin_key(number)] = Pin.new(@io, options.merge(number: number)).apply!
      end
    end

    def release
      @registry.values.each do |pin|
        pin.unexport
      end
      @registry = {}
      self
    end

    private
    def pin_key(number)
      "gpio#{number}"
    end
  end
end
