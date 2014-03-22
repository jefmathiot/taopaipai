require 'spec_helper'

describe Taopaipai::Pin do

  before do
    @io = mock()
    @pin = subject.new(@io, number: 17, direction: :out, value: 1)
  end

  it 'exports the pin then applies the direction and value' do
    io_sequence = sequence('io')
    @io.expects(:export).with(17).in_sequence(io_sequence)
    @io.expects(:direction).with(17, :out).in_sequence(io_sequence)
    @io.expects(:write).with(17, 1).in_sequence(io_sequence)
    @pin.apply!.must_equal @pin
  end

  describe 'on applying direction' do
    
    it 'writes to the io' do
      @io.expects(:direction).with(17, :in)
      @pin.direction(:in).must_equal @pin
    end

    it 'does not do anything if direction stays the same' do
      @io.expects(:direction).never
      @pin.direction(:out).must_equal @pin
    end

  end

  describe 'on applying value' do
    
    it 'writes to the io' do
      @io.expects(:write).with(17, 0)
      @pin.value(0).must_equal @pin
    end

    it 'does not do anything if direction stays the same' do
      @io.expects(:value).never
      @pin.value(1).must_equal @pin
    end

  end

  it 'reads the value' do
    @io.expects(:direction).with(17, :in)
    @io.expects(:read).returns 0
    @pin.direction(:in)
    @pin.value.must_equal 0
  end

  describe 'exporting pin' do

    it 'exports the pin only once' do
      @io.expects(:export).with(17)
      2.times do @pin.export.must_equal @pin end
    end

    it 'does not unexport the pin if not exported' do
      @io.expects(:unexport).never
      @pin.unexport.must_equal @pin
    end

    it 'unexports the pin if exported' do
      export = sequence('export')
      @io.expects(:export).in_sequence(export).with(17)
      @io.expects(:unexport).in_sequence(export).with(17)
      2.times do @pin.export.must_equal @pin end
      2.times do @pin.unexport.must_equal @pin end
    end
  end
end


describe Taopaipai::PinState do

  describe 'assigning direction' do

    before do
      @state = subject.new(number: 17, direction: :out)
    end

    it 'raises and error if direction is invalid' do
      [nil, :none, "none"].each do |dir|
        err = ->{ @state.direction = dir }.must_raise RuntimeError
        err.message.must_match /Invalid direction "#{dir}"/
      end
    end

    it 'assigns the direction' do
      @state.direction = :in
      @state.direction.must_equal :in
    end

  end

  describe 'assigning value' do

    before do
      @state = subject.new(number: 17, direction: :out)
    end

    it 'assigns the value' do
      @state.value = 1
      @state.value.must_equal 1
    end

    it 'raises an error if value is invalid' do
      [-1, 2].each do |v|
        err = ->{@state.value = v}.must_raise RuntimeError
        err.message.must_match /Invalid value "#{v}"/
      end
    end

  end

  it 'assigns pin number, direction and value on initialization' do
    subject.new(number: 17, direction: :out).number.must_equal 17
    subject.new(number: 17, direction: :out).direction.must_equal :out
    subject.new(number: 17, direction: :in).direction.must_equal :in
    subject.new(number: 17, direction: :out).value.must_equal 0
    subject.new(number: 17, direction: :out, value: 1).value.must_equal 1
  end

  describe 'on checking direction' do
    
    before do
      @state = subject.new(number: 17, direction: :out)
    end

    it 'indicates an out pin' do
      @state.in?.must_equal false
      @state.out?.must_equal true
    end
    
    it 'indicates an in pin' do
      @state.direction = :in
      @state.in?.must_equal true
      @state.out?.must_equal false
    end

  end

  it 'marks the pin exported once' do
    state = subject.new(number: 17, direction: :out)
    state.export!.must_equal true
    state.export!.must_equal false
  end

  it 'marks the pin unexported' do
    state = subject.new(number: 17, direction: :out)
    state.export!
    state.unexport!.must_equal true
    state.unexport!.must_equal false
  end

  describe 'on changing attribute' do

    before do
      @state = subject.new(number: 17, direction: :out)
    end

    it 'yields given block if value changed' do
      changed = false
      @state.changing :direction, :in do
        changed = true
      end
      changed.must_equal true
    end

    it 'assigns the value to the attribute' do
      @state.changing :direction, :in
      @state.direction.must_equal :in
    end
  end

end
