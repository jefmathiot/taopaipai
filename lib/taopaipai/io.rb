module Taopaipai
  class IO
    MAX_WRITE_ATTEMPTS = 10

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
    def write_to_file(path, content, attempts = 1)
      begin
        File.open(relative(path), 'w'){|f| f.write(content) }
      rescue => e
        if attempts <= MAX_WRITE_ATTEMPTS
          # Wait 10 ms before retry
          sleep 0.01
          write_to_file(path, content, attemps + 1)
        else
          raise e
        end
      end
    end

    def relative(path)
      "#{@base_path}/#{path}"
    end
  end
end
