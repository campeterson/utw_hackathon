require 'mqtt'
require 'uri'

# Create a hash with the connection parameters from the URL
uri = URI.parse "mqtt://hxwwitvy:W5sARyOu_Bmr@m10.cloudmqtt.com:16973"

conn_opts = {
  remote_host: uri.host,
  remote_port: uri.port,
  username: uri.user,
  password: uri.password,
}
ROOMS = ["r00", "r01", "r02", "r03", "r04", "r05", "r06"]

def build_topic (object_type, object_id, event_type)
  "home/42/#{object_type}/#{object_id}/#{event_type}"
end

def sample_sensors(c)
  message = [TRUE, FALSE].sample
  topic = build_topic(:room, ROOMS.sample, :light)
  c.publish(topic, message)
  puts "Sending data to: #{topic} | #{message}"
end

SIGNAL_QUEUE = []
[:INT, :QUIT, :TERM].each do |signal|
  Signal.trap(signal) {
    SIGNAL_QUEUE << signal
  }
end

MQTT::Client.connect(conn_opts) do |c|
  # publish a message to the topic 'test'
  loop do
    case SIGNAL_QUEUE.pop
    when :INT
      break
    when :QUIT
      break
    when :TERM
      break
    else
      sample_sensors(c)
      sleep 1
    end
  end
end
