$passenger = true

# require './dailies-server.rb'
require ::File.expand_path('../dailies-server',  __FILE__)
run Sinatra::Application
