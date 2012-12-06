require 'httparty'
require 'cgi'

# cat tmp/cities.sm.json | bundle exec soulmate load city
# cat tmp/teams.sm.json | bundle exec soulmate load team

def reload_json_dump_soulmate(t)
	k = t.singularize.classify.constantize
	k.all.each { |s| s.delete }
	
	f = []; 
	IO.readlines("./tmp/#{t}.json").each { |l| f << JSON.parse(l) }
	f.each do |_| 
		p = _.reject { |k,v| ["_id", "slug", "latlon", "url", "bonds"].include?(k) }
		p = p.reject { |k,v| ["zip"].include?(k) } if k == City
		c = k.create(p)
		if !(defined?(_.woeid).nil?)
			l = HTTParty.get('http://query.yahooapis.com/v1/public/yql?q=' + CGI::escape("select latitude, longitude from geo.placefinder where woeid='#{c.woeid}'") + '&format=json').parsed_response['query']['results']['Result']
			c.update_attributes({:latitude => l['latitude'], :longitude => l['longitude']})
			c.save
		elsif (defined?(_["latlon"]))
			c.update_attributes({:latitude => _["latlon"][0], :longitude => _["latlon"][1]})
			c.save
		end
	end
	
	IO.write("./tmp/#{t.pluralize}.sm.json", k.all.map { |t| t.to_soulmate }.join("\n"))
end
	
# ["cities", "teams"].each do |_type|
# 	k = _type.singularize.classify.constantize
# 	k.all.each { |s| s.delete }
# 	
# 	f = []; 
# 	IO.readlines("./tmp/oots.#{_type}.json").each { |l| f << JSON.parse(l) }
# 	f.each { |_| k.create(_.reject { |k,v| ["_id", "statecode", "zip", "latlon", "countrycode", "url", "twitter"].include?(k) }) }
# 	
# 	IO.write("./tmp/#{_type.pluralize}.sm", k.all.map { |t| t.to_soulmate }.join("\n"))
# end
# 
# City.all.each do |c| 
# 	l = HTTParty.get('http://query.yahooapis.com/v1/public/yql?q=' + CGI::escape("select latitude, longitude from geo.placefinder where woeid='#{c.woeid}'") + '&format=json').parsed_response['query']['results']['Result']
# 	c.update_attributes({:latitude => l['latitude'], :longitude => l['longitude']})
# 	c.save
# end
