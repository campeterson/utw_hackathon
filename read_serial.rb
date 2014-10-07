require "serialport"
require 'mqtt'
require 'uri'

#port_str = "/dev/ttyACM0"  #may be different for you
port_str = ARGV[0] || "/dev/tty.usbmodemfd121"  #may be different for you
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

SIGNAL_QUEUE = []
[:INT, :QUIT, :TERM].each do |signal|
  Signal.trap(signal) {
    SIGNAL_QUEUE << signal
  }
end

# just read forever
loop do
  case SIGNAL_QUEUE.pop
  when :INT
    break
  when :QUIT
    break
  when :TERM
    break
  else
    #sample_sensors(c)
    printf("%c", sp.getc)
    #sleep 1
  end
end

sp.close 
