#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'rack'
require 'httparty'
require 'ohm'
require 'ohm/contrib'
require 'active_support/core_ext'

Ohm.connect :url => "redis://localhost:6379/4"

# MongoMapper.connection = Mongo::Connection.new
# MongoMapper.database = "oots" #"-#{ENV['RACK_ENV'] || 'development'}"

Dir.glob("../../lib/**/*.rb") { |f| load f }

Dir[File.join(File.dirname(__FILE__), "..", "..", "app", "models", "*.rb")].each { |file| require file }

# l = IO.readlines('us-state-abbreviations.txt').map { |l| l.chomp }
# ab = {}
# while ((s = l.shift(4)).size > 0) do
# 	ab[s[1]] = s[0]
# end

l = IO.readlines('top-100-cities.txt').map { |l| l.chomp }
cities = []


while ((s = l.shift(5)).size > 0) do
	r = HTTParty.get('http://query.yahooapis.com/v1/public/yql', :format => :json, :query => { 
		:q => "select * from geo.placefinder where text='#{s[1]}, #{s[2]}'",
		:format => "json"
	})
	r = r.parsed_response['query']['results']['Result']

	# attribute :name
	# attribute :state
	# attribute :country
	# attribute :population
	# attribute :radius
	# attribute :latitude
	# attribute :longitude
	
	city = { 
		:name => s[1], 
		:state => r['statecode'],
		# :state => r['state'],
		# :statecode => r['statecode'],
		:country => r['country'],
		# :countrycode => r['countrycode'],
		:radius_m => r['radius'].to_i,
		# :woeid => r['woeid'].to_i,
		# :zip => r['uzip'].to_i,
		:population => s[3].gsub(/\D/,'').to_i,
		:latitude => r['latitude'].to_f,
		:longitude => r['longitude'].to_f
		# :latlon => [r['latitude'].to_f, r['longitude'].to_f]
	}
	mc = City.create(city)
	cities.push(city)
	
	puts "added: #{s[1]}, #{r['statecode']}: #{mc.id}"
end
# 
File.open('cities.json', 'w') { |f| f.write(cities.to_json) }
