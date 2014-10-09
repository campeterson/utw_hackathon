require 'fitgem'
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

config = { oauth: { user_token: "1aace0b79741acf9c3e6842bed278e12", user_secret: "5e9048ac3f0aa93ce2f5415193b99e08", consumer_key: "0e8aa7fcf41d4c1ba8a73ab3c24d8943", consumer_secret: "0723b0f2418c44dbadc04918cff93026" } }

client = Fitgem::Client.new(config[:oauth])
client.reconnect(config[:oauth][:user_token], config[:oauth][:user_secret])

# Send
SIGNAL_QUEUE = []
[:INT, :QUIT, :TERM].each do |signal|
  Signal.trap(signal) {
    SIGNAL_QUEUE << signal
  }
end

def build_topic (object_type, object_id, event_type)
  "home/42/#{object_type}/#{object_id}/#{event_type}"
end

def sample_fitbit(c, client)
  activities = client.activities_on_date('today')
  summary = activities["summary"]
  points = ["activeScore", "caloriesOut", "fairlyActiveMinutes", "lightlyActiveMinutes", "sedentaryMinutes", "steps", "veryActiveMinutes"]

  points.each do |p|
    message = summary[p]
    topic = build_topic(:person, "p00", p)
    c.publish(topic, message)
    puts "Sending data to: #{topic} | #{message}"
  end
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
      sample_fitbit(c, client)
      puts Time.now
      sleep 60
    end
  end
end
