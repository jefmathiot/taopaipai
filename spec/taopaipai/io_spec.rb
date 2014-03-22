require 'spec_helper'
require 'fileutils'

describe Taopaipai::IO do

  before do
    @base_path = 'tmp/sys/class/gpio'
    FileUtils.rm_f @base_path
    FileUtils.mkdir_p "#{@base_path}/gpio17"
    FileUtils.touch "#{@base_path}/gpio17/direction"
    FileUtils.touch "#{@base_path}/gpio17/value"
  end

  def expects_content(path, content)
    File.open(path, 'r'){|file| file.read}.must_equal content
  end

  def io
    subject.new(@base_path)
  end

  it 'exports pin' do
    io.export(17)
    expects_content "#{@base_path}/export", "17"
  end

  it 'unexports pin' do
    io.unexport(17)
    expects_content "#{@base_path}/unexport", "17"
  end

  it 'changes pin direction' do
    io.direction(17, :in)
    expects_content "#{@base_path}/gpio17/direction", "in"
  end
  
  it 'reads pin value' do
    File.open("#{@base_path}/gpio17/value", 'w'){|file| file.write "1" }
    io.read(17).must_equal "1"
  end

  it 'reads pin value' do
    io.write(17, "0")
    expects_content "#{@base_path}/gpio17/value", "0"
  end

end
