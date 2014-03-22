require "taopaipai/version"
require "taopaipai/io"
require "taopaipai/pin"
require "taopaipai/gpio"

module Taopaipai
  class << self
    def gpio
      @gpio ||= GPIO.new
    end
  end
end
