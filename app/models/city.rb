class City < Ohm::Model

	attribute :name
	attribute :state
	attribute :statecode
	attribute :country
	attribute :countrycode
	attribute :population
	attribute :radius
	attribute :woeid
	attribute :url
	attribute :latitude
	attribute :longitude
	# attribute :geohash
	attribute :slug; index :slug
	include Ohm::Callbacks

	# include Redis::Objects
	# sorted_set :geohashes, :global => true

	cattr_accessor :kdtree do
		Kdtree.new(City.all.map { |c| [c.latitude.to_f, c.longitude.to_f, c.id.to_i] })
	end
	
	def before_save
		self.slug = "#{self.name} #{self.state}".dasherize
		# City.geohashes[self.id] = self.geohash = Base32::Crockford.decode(GeoHash.encode(self.latitude.to_f, self.longitude.to_f)).to_i
	end

	def to_s
		"#{name}, #{state}"
	end
	
	def permalink
		"/cities/#{slug}"
	end

	def to_soulmate
		# {"id":1,"term":"Dodger Stadium","score":85,"data":{"url":"\/dodger-stadium-tickets\/","subtitle":"Los Angeles, CA"}}
		{ :id => id, :term => self.to_s, :score => population.to_i, :data => { :url => permalink, :subtitle => country }}.to_json
	end

	# key :name, String, :required => true
	# key :slug, String, :required => true, :unique => true
	# key :state, String
	# key :statecode, String
	# key :country, String
	# key :countrycode, String
	# key :radius, Integer
	# key :woeid, Integer
	# key :population, Integer
	# key :latlon, Array
	# 
	# before_validation do |c|
	# 	c.slug = "#{c.name} #{c.statecode}".dasherize
	# end
end
