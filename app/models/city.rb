class City
	include MongoMapper::Document
	
	key :name, String, :required => true, :index => true 
	key :slug, String, :required => true, :index => true
	key :state, String
	key :statecode, String
	key :statecode, String
	key :country, String
	key :countrycode, String
	key :radius, Integer
	key :woeid, Integer
	key :population, Integer
	key :latlon, Array

	before_validation do |c|
		c.slug = "#{c.name} #{c.statecode} #{c.countrycode}".dasherize
	end
end
