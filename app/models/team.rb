class Team
	include MongoMapper::Document
	plugin MongoMapper::Plugins::IdentityMap
	
	key :name, String, :required => true, :index => true 
	key :slug, String, :required => true, :index => true
	key :definite_article, Boolean
	key :sport, String
	key :league, String
	# key :altnames, Array	
	key :city, String
	key :country, String
	key :url, String
	key :twitter, String
	timestamps!
	
	def self.normalize_params(params)
		params.merge({
			'tags' => params[:tagstring].split(',').map(&:strip).map { |t| { 'title' => t }},
			'places' => (params[:places] || []).map { |p| Place.find(p) },
			'neighborhoods' => (params[:neighborhoods] || []).map { |p| Neighborhood.find(p) },
			'people' => (params[:people] || []).map { |p| Person.find(p) },
			'blog' => Blog.find(params[:blog_id]),
			'published_at' => Chronic.parse(params[:published_at])
		})
	end

	before_validation do |t|
		t.slug = t.name.dasherize
	end

	def permalink
		"/teams/#{slug}"
	end

end