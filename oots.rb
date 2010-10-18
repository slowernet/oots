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
require 'bin'
require 'joint'
# require 'open-uri'
# require 'sinatra/reloader' if development?	# http://github.com/rkh/sinatra-reloader
# require 'rack/gridfs' # only needed in the absence of nginx-gridfs mod; http://github.com/mdirolf/nginx-gridfs
# require 'nokogiri'
# require 'prism'	# microformats; http://github.com/mwunsch/prism

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
	
	CACHE = ActiveSupport::Cache.lookup_store(Bin::Store.new(MongoMapper.database['cache']))

	helpers AssetBundler::ViewHelper	# http://github.com/gbuesing/asset_bundler	
end

Dir[File.join(File.dirname(__FILE__), "app", "models", "*.rb")].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), "app", "controllers", "*.rb")].each { |file| require file }
# require 'app/helpers'

get '/' do
	# @teams = CACHE.fetch("teams") do
		@teams = Team.all.map { |t| { :label => t.name, :id => t.id, :definite_article => t.definite_article }}
	# end
	erb :'venues/search'
end

get '/venues/search' do
	respond_to do |wants|
		wants.html { erb :'venues/search' }
		wants.js {
			
		}
	end
end

get '/teams/new' do
	@form = { :method => 'post', :endpoint => '/teams' }
	@team = Team.new
	erb :'teams/edit'
end

get '/teams/:slug' do
	@team = Team.find_by_slug(params[:slug])
	erb :'teams/show'
end

get '/teams/:slug/edit' do
	@team = Team.find_by_slug(params[:slug])
	@form = { :method => 'put', :endpoint => '/teams' }
	erb :'teams/edit'
end

put '/teams' do
	team = Team.find(params[:team][:id])
	team.update_attributes!(params[:team])
	redirect team.permalink
end

post '/teams' do
	team = Team.create!((params[:team]))
	redirect team.permalink
end