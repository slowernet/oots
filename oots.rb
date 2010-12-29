begin
	require 'sinatra'
rescue LoadError
	require 'rubygems'
	require 'sinatra'
end

require 'active_support'; $KCODE = 'u'
require 'sinatra_more/markup_plugin' # http://github.com/nesquena/sinatra_more
require 'sinatra_more/render_plugin'
require 'sinatra/respond_to' # http://github.com/cehoffman/sinatra-respond_to
require 'mongo_mapper'
# require 'bin'
# require 'joint'
# require 'open-uri'
# require 'rack/gridfs' # only needed in the absence of nginx-gridfs mod; http://github.com/mdirolf/nginx-gridfs


# http://ipinfodb.com/ip_location_api.php
# $IPINFODB_API_KEY = '0c3dfc109da55ad6220ba55e2baaf44af5da8469ee19bb4be59820917acf8fa1'

set :views, File.join(File.dirname(__FILE__), "app", "views")

Dir.glob("lib/**/*.rb") { |f| load f }

module Sinatra
	register SinatraMore::MarkupPlugin
	register SinatraMore::RenderPlugin
	register Sinatra::RespondTo
end

use Rack::JSONP

configure do
	CONFIG = JSON.parse(IO.read("#{File.dirname(__FILE__)}/config.json")).select { |k,v| ['default', Sinatra::Application.environment.to_s].include?(k) }.map { |a| a.last }.inject({}) { |m,e| m.merge(e) }	

	MongoMapper.connection = Mongo::Connection.new(CONFIG['db']['host'], CONFIG['db']['port'])
	MongoMapper.database = CONFIG['db']['name']
	MongoMapper.handle_passenger_forking
	
	# use Rack::GridFS, :hostname => 'localhost', :port => 27017, :database => dbname, :prefix => 'images/gridfs'
	
	# CACHE = ActiveSupport::Cache.lookup_store(Bin::Store.new(MongoMapper.database['cache']))

	helpers AssetBundler::ViewHelper	# http://github.com/gbuesing/asset_bundler	
end

Dir[File.join(File.dirname(__FILE__), "app", "models", "*.rb")].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), "app", "controllers", "*.rb")].each { |file| require file }
# require 'app/helpers'

#####################

def format_phone(p)
	p.gsub!(/\D/,'')
	"#{p[0..2]} #{p[3..5]} #{p[6..9]}"
end

def teams_for_select
	Team.all(:order => 'name').map { |t| { 
		:id => t.id, 
		:label => t.name, 
		:altnames => t.altnames, 
		:the => t.the
	}}
end

get '/' do
	# @teams = CACHE.fetch("teams") do
	# end
	@teams = teams_for_select
	erb :'venues/search'
end

get '/about' do
	erb :'meta/about'
end

get '/sitemap' do
	respond_to do |wants|
		wants.xml {
			@venues = Venue.all
			@cities = City.all
			@teams = Team.all
			erb :'meta/sitemap'
		}
	end
end

get "/#{CONFIG['secret']}" do
	response.set_cookie('admin', CONFIG['secret']);
	redirect '/'
end