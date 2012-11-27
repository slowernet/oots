class Team < Ohm::Model
	
	attribute :name
	set :altnames, String
	attribute :the
	attribute :sport
	attribute :league
	attribute :city
	attribute :country
	attribute :altnames
	attribute :slug; index :slug
	include Ohm::Timestamps
	include Ohm::Callbacks
	
	def before_save
		self.slug = self.name.dasherize
	end

	def definite_name
		(the.eql?('true') ? 'the ' : '') + name
	end

	def permalink
		"/teams/#{slug}"
	end

	def to_soulmate
		# {"id":1,"term":"Dodger Stadium","score":85,"data":{"url":"\/dodger-stadium-tickets\/","subtitle":"Los Angeles, CA"}}
		{ :id => id, :term => name, :score => 1, :data => { :url => permalink, :subtitle => "#{city}, #{country}" }}.to_json
	end

	# include MongoMapper::Document
	# plugin MongoMapper::Plugins::IdentityMap
	
	# key :name, String, :required => true
	# key :slug, String, :required => true, :unique => true
	# key :the, Boolean
	# key :sport, String
	# key :league, String
	# key :altnames, String	
	# key :city, String
	# key :country, String
	# key :url, String
	# key :twitter, String
	# timestamps!
	
	# def self.normalize_params(params)
	# 	params.merge({
	# 		'tags' => params[:tagstring].split(',').map(&:strip).map { |t| { 'title' => t }},
	# 		'places' => (params[:places] || []).map { |p| Place.find(p) },
	# 		'neighborhoods' => (params[:neighborhoods] || []).map { |p| Neighborhood.find(p) },
	# 		'people' => (params[:people] || []).map { |p| Person.find(p) },
	# 		'blog' => Blog.find(params[:blog_id]),
	# 		'published_at' => Chronic.parse(params[:published_at])
	# 	})
	# end
	# 
end