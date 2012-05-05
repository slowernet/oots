# oots

require 'rubygems'
require 'sinatra'
require 'active_support'; $KCODE = 'u'
require 'sinatra_more/markup_plugin' # http://github.com/nesquena/sinatra_more
require 'sinatra_more/render_plugin'
require 'sinatra/respond_to' # http://github.com/cehoffman/sinatra-respond_to
require 'mongo_mapper'
# require 'oj'
# require 'bin'
# require 'joint'
# require 'open-uri'
# require 'rack/gridfs' # only needed in the absence of nginx-gridfs mod; http://github.com/mdirolf/nginx-gridfs

set :views, File.join(File.dirname(__FILE__), "app", "views")
set :logger_level, :info if development?
set :dump_errors, true if development?
enable :raise_errors

%w(lib config).each { |path| Dir.glob("#{path}/**{,/*/**}/*.rb") { |f| load f } }
CONFIG = CONFIG['default'].recursive_merge(CONFIG[Sinatra::Application.environment.to_s])

module Sinatra
	register SinatraMore::MarkupPlugin
	register SinatraMore::RenderPlugin
	register Sinatra::RespondTo
end

use Rack::JSONP

configure do
	
	# CONFIG = Oj::Doc.parse(IO.read("#{File.dirname(__FILE__)}/config.json")).select { |k,v| ['default', Sinatra::Application.environment.to_s].include?(k) }.map { |a| a.last }.inject({}) { |m,e| m.merge(e) }	

	MongoMapper.connection = Mongo::Connection.new(CONFIG['db']['host'], CONFIG['db']['port'])
	MongoMapper.database = CONFIG['db']['name']
	MongoMapper.handle_passenger_forking
	
	# use Rack::GridFS, :hostname => 'localhost', :port => 27017, :database => dbname, :prefix => 'images/gridfs'
	
	# CACHE = ActiveSupport::Cache.lookup_store(Bin::Store.new(MongoMapper.database['cache']))

	helpers AssetBundler::ViewHelper	# http://github.com/gbuesing/asset_bundler	
	helpers TemplateBundler::ViewHelper
end

%w(models controllers helpers).each { |path| Dir[File.join(File.dirname(__FILE__), "app", path, "*.rb")].each { |f| require f } }
