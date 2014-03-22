require 'spec_helper'

describe Taopaipai::GPIO do

  before do
    Taopaipai::IO.expects(:new).with('/sys/class/gpio').returns(@io = mock)
    @gpio = subject.new
  end

  describe 'retrieving pin' do
   
    def expect_pin_creation
      @gpio.pin(17, direction: :in).must_equal @pin
    end

    before do
      Taopaipai::Pin.expects(:new).once.with(@io, direction: :in, number: 17).returns(@pin = mock)
      @pin.expects(:apply!).returns(@pin)
    end

    it 'creates and applies a new pin if it does not exist' do
      expect_pin_creation
    end
    
    it 'reuse the same pin over and over again' do
      expect_pin_creation
      @gpio.pin(17).must_equal @pin
    end
    
    it 'changes existing pins on the fly using the given options' do
      expect_pin_creation
      @pin.expects(:direction).with(:out)
      @pin.expects(:value).with(1)
      @gpio.pin(17, direction: :out, value: 1).must_equal @pin
    end
  end

  it 'release pins' do
    pin_sequence = sequence('pins')
    
    Taopaipai::Pin.expects(:new).in_sequence(pin_sequence).
      with(@io, direction: :in, number: 17).returns(@first = mock)
    @first.expects(:apply!).in_sequence(pin_sequence).returns(@first)
    Taopaipai::Pin.expects(:new).in_sequence(pin_sequence).
      with(@io, direction: :in, number: 27).returns(@last = mock)
    @last.expects(:apply!).in_sequence(pin_sequence).returns(@last)

    @first.expects(:unexport).in_sequence(pin_sequence)
    @last.expects(:unexport).in_sequence(pin_sequence)
    
    @gpio.pin(17, direction: :in)
    @gpio.pin(27, direction: :in)
    @gpio.release.must_equal @gpio
  end

end
