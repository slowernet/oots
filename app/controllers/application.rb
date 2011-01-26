get '/' do
	# @teams = CACHE.fetch("teams") do
	# end
	@teams = teams_for_select
	erb :'venues/search'
end

get '/about' do
	erb :'meta/about'
end

get '/sitemap' do
	respond_to do |wants|
		wants.xml {
			@venues = Venue.all
			@cities = City.all
			@teams = Team.all
			erb :'meta/sitemap'
		}
	end
end

get "/#{CONFIG['secret']}" do
	response.set_cookie('admin', CONFIG['secret']);
	redirect '/'
end

not_found do
	redirect '/'
end

error 500..510 do
	redirect '/'
end