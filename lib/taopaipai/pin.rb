module Taopaipai
  class Pin

    def initialize(io, options={})
      @io = io
      @state = PinState.new(options)
    end

    def apply!
      export.apply_direction.apply_value
    end

    def direction(direction)
      @state.changing :direction, direction do
        apply_direction
      end
      self
    end
    
    def value(value = nil)
      if @state.out?
        @state.changing :value, value do
          apply_value
        end
        self
      else
        @state.value = @io.read(@state.number)
      end
    end
    
    def unexport
      @io.unexport(@state.number) if @state.unexport!
      self
    end
    
    def export
      @io.export(@state.number) if @state.export!
      self
    end

    protected

    def apply_direction
      @io.direction(@state.number, @state.direction)
      self
    end

    def apply_value
      if @state.out? && @state.value
        @io.write(@state.number, @state.value)
      end
      self
    end

  end

  class PinState
    attr_reader :number, :direction, :value

    def initialize(options={})
      @number = options[:number]
      self.direction = options[:direction]
      self.value = options[:value]
    end

    def changing(attribute, update)
      if send(attribute) != update
        send "#{attribute}=", update
        yield if block_given?
      end
    end

    def direction=(direction)
      direction = direction.to_s.to_sym
      unless [:in, :out].include?(direction)
        raise "Invalid direction \"#{direction}\", should be one of \"in\", \"out\""
      end
      @direction = direction
    end

    def value=(v)
      v = v.to_i
      unless (0..1).include?(v)
        raise "Invalid value \"#{v}\", should be one of 0, 1"
      end
      @value = v
    end

    def in?
      direction == :in
    end
    
    def out?
      direction == :out
    end

    def export!
      return false if @exported
      @exported = true
    end
    
    def unexport!
      return false unless @exported
      @exported = false
      true
    end
  end
end
