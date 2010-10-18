class Venue
	include MongoMapper::Document
	plugin MongoMapper::Plugins::IdentityMap
	
	key :name, String, :required => true, :index => true 
	key :slug, String, :required => true, :index => true
	key :address, String
	key :city, String
	key :state, String
	key :zip, String
	key :crossstreet, String
	key :latlon, Array
	key :phone, String
	key :foursquare_id, Integer
	key :url, String
	key :twitter, String
	key :team_ids, Array, :typecast => 'ObjectId'
	many :teams, :in => :team_ids
	timestamps!

	attr_accessor :lat, :lon

	ensure_index [[ 'latlon', '2d' ]]	
	
	# scope :in_neighborhood, lambda { |slug| where('location.neighborhood.slug' => slug) }
	
	before_validation do |place|
		place.slug = "#{place.name} #{place.city}".dasherize
	end

	def permalink
		"/places/#{slug}"
	end

end