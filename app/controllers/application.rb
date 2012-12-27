get '/' do
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

get "/#{$config[:secret]}" do
	response.set_cookie('admin', $config[:secret]);
	redirect '/'
end

get '/cities/?' do
	@k = City.all
	erb :'cities/index'
end

get "/cities/:slug" do
	pass unless @city = City.find(:slug => params[:slug]).first
	@closest = City.kdtree.nearestk(@city.latitude.to_f, @city.longitude.to_f, 21).drop(1)
	erb :'cities/show'
end

not_found do
	redirect '/'
end

error 500..510 do
	redirect '/'
end

get '/wte/?' do
	erb :'venues/wte'
end