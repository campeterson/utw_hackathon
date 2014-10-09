require "serialport"
require 'mqtt'
require 'uri'

#port_str = "/dev/ttyACM0"  #may be different for you
port_str = ARGV[0] || "/dev/tty.usbmodemfd121"  #may be different for you
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

#SIGNAL_QUEUE = []
#[:INT, :QUIT, :TERM].each do |signal|
  #Signal.trap(signal) {
    #SIGNAL_QUEUE << signal
  #}
#end

uri = URI.parse "mqtt://hxwwitvy:W5sARyOu_Bmr@m10.cloudmqtt.com:16973"

conn_opts = {
  remote_host: uri.host,
  remote_port: uri.port,
  username: uri.user,
  password: uri.password,
}

OBJECTS = {
  room: ["r00", "r01", "r02", "r03", "r04", "r05", "r06"],
  person: ["p00"]
}

def parse_data(data)
  unless data.nil?
    tmp = data.split('/')

    return tmp[0], tmp[1], tmp[2]
  else
    return nil, nil, nil
  end
end

def build_topic (object_type, object_id, event_type)
  "home/42/#{object_type}/#{object_id}/#{event_type}"
end

def get_object_type(key)
  if [:temp, :light].include?(key.to_sym)
    :room
  elsif [:upright, :activity, :pills].include?(key.to_sym)
    :person
  end
end

def send_data(c, data)
  object_id, event_type, message = parse_data(data)
  if object_id && event_type && message
    object_type = get_object_type(event_type)
    if object_type
      topic = build_topic(object_type, object_id, event_type)
      c.publish(topic, message.to_s.downcase)
      puts "Sending data to: #{topic} | #{message}"
    end
  else
    puts "parse died"
  end
end

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

# just read forever
MQTT::Client.connect(conn_opts) do |c|
  #send_data(c, "activity|99")
  #send_data(c, "upright|false")
  while true do
    while (i = sp.gets.chomp) do       # see note 2
      if i
        send_data(c, i)
      end
    end
  end
  #while (i = sp.gets.chomp) do       # see note 2
    #case SIGNAL_QUEUE.pop
    #when :INT
      #break
    #when :QUIT
      #break
    #when :TERM
      #break
    #else
      #send_data(i)
      ##puts i
      ##printf("%c", sp.getc)
      ##sample_sensors(c)
      ##sleep 1
    #end
  #end
end

sp.close 
