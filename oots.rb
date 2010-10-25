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


$SECRET = '2f0226e3ad7560db28c6e41c1d92e394'
$BASE_URL = 'http://outoftownsports.com'

set :views, File.join(File.dirname(__FILE__), "app", "views")

Dir.glob("lib/**/*.rb") { |f| load f }

module Sinatra
	register SinatraMore::MarkupPlugin
	register SinatraMore::RenderPlugin
	register Sinatra::RespondTo
end

use Rack::JSONP

configure do
	dbname = "oots"
	MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017, :logger => Logger.new('log/db.log')) if development?
	MongoMapper.database = dbname
	MongoMapper.handle_passenger_forking
	
	# use Rack::GridFS, :hostname => 'localhost', :port => 27017, :database => dbname, :prefix => 'images/gridfs'
	
	# CACHE = ActiveSupport::Cache.lookup_store(Bin::Store.new(MongoMapper.database['cache']))

	helpers AssetBundler::ViewHelper	# http://github.com/gbuesing/asset_bundler	
end

Dir[File.join(File.dirname(__FILE__), "app", "models", "*.rb")].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), "app", "controllers", "*.rb")].each { |file| require file }
# require 'app/helpers'

#####################

def teams_for_select
	Team.all(:order => 'name').map { |t| { 
		:id => t.id, 
		:label => t.name, 
		:altnames => t.altnames, 
		:definite_article => t.definite_article
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

get "/#{$SECRET}" do
	response.set_cookie('admin', $SECRET);
	redirect '/'
end