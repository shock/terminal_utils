require "stringio"

class OutputBuffer
  
  def initialize
    @buffer = StringIO.new
    activate
  end
  
  def activate
    $stdout = @buffer
  end
  
  def to_s
    @buffer.rewind
    @buffer.read
  end
  
  def stop
    OutputBuffer::restore_default
  end
  
  def self.restore_default
    $stdout = STDOUT
  end
  
  def self.capture &block
    buffer = OutputBuffer.new
    block.call
    buffer.stop
    buffer.to_s
  end
  
end

