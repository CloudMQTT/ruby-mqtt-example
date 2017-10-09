require 'mqtt'
require 'uri'

# Create a hash with the connection parameters from the URL
uri = URI.parse ENV['CLOUDMQTT_URL'] || 'mqtt://localhost:1883'
conn_opts = {
  remote_host: uri.host,
  remote_port: uri.port,
  username: uri.user,
  password: uri.password
}
topic = uri.path[1, uri.path.length] || 'test'

# Subscribe example
Thread.new do
  MQTT::Client.connect(conn_opts) do |c|
    # The block will be called when you messages arrive to the topic
    c.get(topic) do |t, message|
      puts "#{t}: #{message}"
    end
  end
end

# Publish example
MQTT::Client.connect(conn_opts) do |c|
  # publish a message to the topic 'test'
  loop do
    c.publish(topic, 'Hello World')
    sleep 1
  end
end
