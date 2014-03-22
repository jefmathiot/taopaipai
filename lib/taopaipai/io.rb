module Taopaipai
  class IO
    def initialize(base_path)
      @base_path = base_path
    end

    def export(pin)
      write_to_file('export', pin.to_s)
    end

    def unexport(pin)
      write_to_file('unexport', pin.to_s)
    end

    def direction(pin, direction)
      write_to_file("gpio#{pin}/direction", direction)
    end

    def read(pin)
      File.open(relative("gpio#{pin}/value"), 'r'){|f| f.read }
    end

    def write(pin, value)
      write_to_file("gpio#{pin}/value", value)
    end

    private
    def write_to_file(path, content)
      File.open(relative(path), 'w'){|f| f.write(content) }
    end

    def relative(path)
      "#{@base_path}/#{path}"
    end
  end
end
