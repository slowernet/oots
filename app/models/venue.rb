# class Bond
# 	include MongoMapper::EmbeddedDocument
# 
# 	key :team_id, ObjectId
# 	belongs_to :team
# 	key :strength, Integer
# 	key :note, String
# end

class Venue < Ohm::Model
	attribute :name
	attribute :address
	attribute :zip
	attribute :crossstreet
	attribute :city
	attribute :state
	attribute :phone
	attribute :latitude
	attribute :longitude
	attribute :foursquare_id
	attribute :twitter
	attribute :slug; index :slug
	include Ohm::Timestamps
	include Ohm::Callbacks
	
	def before_save
		self.slug = "#{self.name} #{self.address} #{self.city}".dasherize
	end

	def to_soulmate
		# {"id":1,"term":"Dodger Stadium","score":85,"data":{"url":"\/dodger-stadium-tickets\/","subtitle":"Los Angeles, CA"}}
		{ :id => id, :term => name, :score => 1, :data => { :url => permalink, :subtitle => "#{city}, #{state}" }}.to_json
	end

	def permalink
		"/venues/#{slug}"
	end
	
	# include MongoMapper::Document
	# plugin MongoMapper::Plugins::IdentityMap
	
	# key :name, String, :required => true
	# key :slug, String, :required => true, :unique => true
	# many :bonds
	# key :address, String
	# key :city, String
	# key :state, String
	# key :zip, String
	# key :crossstreet, String
	# key :latlon, Array
	# key :phone, String
	# key :foursquare_id, Integer, :unique => true
	# key :url, String
	# key :twitter, String
	# timestamps!
	# 
	# attr_accessor :lat, :lon
	# 
	# ensure_index [[ 'latlon', '2d' ]]	
	
	# before_validation do |venue|
	# 	venue.slug = "#{venue.name} #{venue.address} #{venue.city}".dasherize
	# end

	# def permalink
	# 	"/venues/#{slug}"
	# end

	# def self.count_for_team(team)
	# 	Venue.where('bonds.team_id' => team.id).count
	# end
	
end