get '/venues/new' do
	@form = { :method => 'post', :endpoint => '/venues' }
	@venue = Venue.new
	@team = Team.find_by_slug(params[:team]) if params[:team]
	erb :'venues/edit'
end

get '/venues/search' do
	respond_to do |wants|
		wants.html { redirect '/' }
		wants.js {
			content_type 'application/json', :charset => 'utf-8'
			if params[:foursquare_id]
				Venue.where(:foursquare_id => params[:foursquare_id].to_i).all.to_json
			elsif params
				Venue.where("bonds.team_id" => BSON::ObjectId(params[:team_id])).all.to_json
			end
		}
	end
end

get '/venues/:slug' do
	@venue = Venue.find_by_slug(params[:slug])
	@teams = teams_for_select
	erb :'venues/show'
end

get '/venues/:slug/edit' do
	@venue = Venue.find_by_slug(params[:slug])
	@form = { :method => 'put', :endpoint => '/venues' }
	erb :'teams/edit'
end

get '/venues/f/:foursquare_id' do
	venue = Venue.where(:foursquare_id => params[:foursquare_id].to_i).all.first
	redirect venue.permalink
end

post '/venues' do
	p = params[:venue]
	p.merge!({ 'latlon' => [ p.delete('lat').to_f, p.delete('lon').to_f ] })
	venue = Venue.create!(p)
	redirect venue.permalink
end

get "/venues" do
	redirect '/' unless (request.cookies['admin'] == CONFIG['secret'])
	@venues = Venue.all(:order => 'country, state, city, name')
	erb :'venues/index'
end

post '/venues/:slug/bonds' do
	# params.inspect
	venue = Venue.find_by_slug(params[:slug])
	venue.bonds << Bond.new(params[:bond])
	venue.save
	redirect venue.permalink
end