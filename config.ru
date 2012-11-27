require 'bundler'
Bundler.require

require './oots'
require 'soulmate/server'

run Rack::URLMap.new({ 
    "/" => Sinatra::Application,
	"/autocomplete" => Soulmate::Server
})