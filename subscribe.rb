require 'mqtt'
require 'uri'

home_topic = "home/42/#"

uri = URI.parse "mqtt://hxwwitvy:W5sARyOu_Bmr@m10.cloudmqtt.com:16973"

conn_opts = {
  remote_host: uri.host,
  remote_port: uri.port,
  username: uri.user,
  password: uri.password,
}

MQTT::Client.connect(conn_opts) do |c|
  c.get(home_topic) do |topic, message|
    puts "#{topic}: #{message}"
  end
end
