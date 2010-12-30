get '/teams' do
  @teams = Team.all(:order => 'country, league, name')
  erb :'teams/index'
end

get '/teams/new' do
	redirect '/' unless (request.cookies['admin'] == CONFIG['secret'])
	@form = { :method => 'post', :endpoint => '/teams' }
	@team = Team.new
	erb :'teams/edit'
end

get '/teams/:slug' do
	redirect "/t/#{params[:slug]}", 301
end

get '/t/:slug' do
	@team = Team.find_by_slug(params[:slug])
	erb :'teams/show'
end

get '/teams/:slug/edit' do
	@team = Team.find_by_slug(params[:slug])
	@form = { :method => 'put', :endpoint => '/teams' }
	erb :'teams/edit'
end

get '/:team_slug/in/:city_slug' do
	team = Team.where(:name => Regexp.new(params[:team_slug], 'i')).first	# legacy
	redirect "/t/#{team.slug}/in/#{params[:city_slug]}", 301
end

get '/t/:team_slug/in/:city_slug' do
	@team = Team.find_by_slug(params[:team_slug])
	@city = City.find_by_slug(params[:city_slug])
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