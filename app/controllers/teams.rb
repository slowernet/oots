get '/teams/?' do
	# fold the team list by league and sport
	@sports = Team.all.inject({}) { |acc, v| 
		(acc[v.league] ||= []) << v; acc
	}.inject({}) { |acc, (k,v)|
		(acc[v.first.sport] ||= {})[k] = v; acc
	}
	erb :'teams/index'
end

get '/teams/new' do
	redirect '/' unless (request.cookies['admin'] == $config[:secret])
	@form = { :method => 'post', :endpoint => '/teams' }
	@team = Team.new
	erb :'teams/edit'
end

get '/teams/:slug/?' do
	pass unless @team = Team.find(:slug => params[:slug]).first
	# @venues = Venue.where('bonds.team_id' => @team.id).all
	erb :'teams/show'
end

get '/:slug/edit' do
	pass unless @team = Team.find_by_slug(params[:slug])
	@form = { :method => 'put', :endpoint => '/teams' }
	erb :'teams/edit'
end

get '/:team_slug/:city_slug' do
	pass unless @team = Team.find(:slug => params[:team_slug]).first
	@city = City.find(:slug => params[:city_slug]).first
	# @venues = Venue.where({ :latlon => { "$within" => { "$center" => [ @city.latlon, ((@city.radius) / 1000 / 111.0) ] }}}).where("bonds.team_id" => @team.id).all
	erb :'teams/in'
end

put '/teams' do
	team = Team.find(params[:team][:id])
	team.update_attributes!(params[:team])
	redirect team.permalink
end

post '/teams' do
	team = Team.create!(params[:team])
	redirect team.permalink
end

# redirects

get '/:team_slug/in/:city_slug' do
	team = Team.where(:slug => Regexp.new(params[:team_slug], 'i')).first	# legacy
	redirect "/#{team.slug}/#{params[:city_slug].sub(/-us$/, '')}", 301
end

