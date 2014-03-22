require 'spec_helper'

describe Taopaipai do

  it 'creates a single GPIO' do
    Taopaipai::GPIO.expects(:new).once.returns(gpio = mock)
    2.times do
      Taopaipai.gpio.must_equal gpio
    end
  end

end
