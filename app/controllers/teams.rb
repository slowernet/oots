get '/teams' do
	# fold the team list by league and sport
	@sports = Team.all(:order => 'name').inject({}) { |acc, v| 
		(acc[v.league] ||= []) << v; acc
	}.inject({}) { |acc, (k,v)|
		(acc[v.first.sport] ||= {})[k] = v; acc
	}.sort
	erb :'teams/index'
end

get '/teams/new' do
	redirect '/' unless (request.cookies['admin'] == CONFIG['secret'])
	@form = { :method => 'post', :endpoint => '/teams' }
	@team = Team.new
	erb :'teams/edit'
end

get '/:slug/?' do
	pass unless @team = Team.find_by_slug(params[:slug])
	@venues = Venue.where('bonds.team_id' => @team.id).all
	erb :'teams/show'
end

get '/:slug/edit' do
	pass unless @team = Team.find_by_slug(params[:slug])
	@form = { :method => 'put', :endpoint => '/teams' }
	erb :'teams/edit'
end

get '/:team_slug/:city_slug' do
	pass unless @team = Team.find_by_slug(params[:team_slug])
	@city = City.find_by_slug(params[:city_slug])
	@venues = Venue.where({ :latlon => { "$within" => { "$center" => [ @city.latlon, ((@city.radius) / 1000 / 111.0) ] }}}).where("bonds.team_id" => @team.id).all
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

get '/teams/:slug' do
	redirect "#{params[:slug]}", 301
end

get '/:team_slug/in/:city_slug' do
	team = Team.where(:slug => Regexp.new(params[:team_slug], 'i')).first	# legacy
	redirect "/#{team.slug}/#{params[:city_slug].sub(/-us$/, '')}", 301
end

