require 'mqtt'
require 'uri'

# Create a hash with the connection parameters from the URL
uri = URI.parse ENV['CLOUDMQTT_URL'] || 'mqtt://localhost:1883'
conn_opts = {
  remote_host: uri.host,
  remote_port: uri.port,
  username: uri.user,
  password: uri.password,
}

# Subscribe example
Thread.new do
  MQTT::Client.connect(conn_opts) do |c|
    # The block will be called when you messages arrive to the topic
    c.get('test') do |topic, message|
      puts "#{topic}: #{message}"
    end
  end
end

# Publish example
MQTT::Client.connect(conn_opts) do |c|
  # publish a message to the topic 'test'
  loop do
    c.publish('test', 'Hello World')
    sleep 1
  end
end

