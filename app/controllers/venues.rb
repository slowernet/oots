get '/venues/new' do
	@form = { :method => 'post', :endpoint => '/venues' }
	@venue = Venue.new
	erb :'venues/edit'
end

get '/venues/search' do
	respond_to do |wants|
		wants.html { redirect '/' }
		wants.js {
			if params[:foursquare_id]
				Venue.where(:foursquare_id => params[:foursquare_id].to_i).all.to_json
			else
				Venue.where("bonds.team_id" => params[:team_id]).where(:latlon => {'$near' => [ params[:lat].to_f, params[:lon].to_f ]}).limit(25).all.to_json
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
	venue = Venue.create!(params[:venue])
	redirect venue.permalink
end

get "/venues" do
	redirect '/' unless (request.cookies['admin'] == $SECRET)
	@venues = Venue.all
	erb :'venues/index'
end

post '/venues/:slug/bonds' do
	params.inspect
#	@venue = Venue.find_by_slug(params[:slug])
#	@venue.bonds << Bond.new({params[:bond]})
end