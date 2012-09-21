class Team < Ohm::Model
	# include MongoMapper::Document
	# plugin MongoMapper::Plugins::IdentityMap
	
	attribute :name
	attribute :the
	attribute :sport
	attribute :country
	include Ohm::Timestamps
	
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
	# before_validation do |t|
	# 	t.slug = "#{t.name}".dasherize
	# end
	# 
	# def definite_name
	# 	(the ? 'the ' : '') + name
	# end
	# 
	# def permalink
	# 	"/#{slug}"
	# end

end