class Bond
	include MongoMapper::EmbeddedDocument

	key :team_id, ObjectId
	key :strength
	key :note, String
end

class Venue
	include MongoMapper::Document
	plugin MongoMapper::Plugins::IdentityMap
	
	key :name, String, :required => true, :index => true 
	key :slug, String, :required => true, :index => true
	many :bonds
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
	timestamps!

	attr_accessor :lat, :lon

	ensure_index [[ 'latlon', '2d' ]]	
	
	before_validation do |venue|
		venue.slug = "#{venue.name} #{venue.address} #{venue.city}".dasherize
	end

	def permalink
		"/venues/#{slug}"
	end

end