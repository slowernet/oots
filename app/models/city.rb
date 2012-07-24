class City < Ohm::Model

	attribute :name
	attribute :state
	attribute :country
	attribute :radius
	attribute :population

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
