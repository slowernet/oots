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

get "/#{$config[:secret]}" do
	response.set_cookie('admin', $config[:secret]);
	redirect '/'
end

not_found do
	redirect '/'
end

error 500..510 do
	redirect '/'
end

def format_phone(p)
	p.gsub!(/\D/,'')
	"#{p[0..2]} #{p[3..5]} #{p[6..9]}"
end

def teams_for_select
	Team.all.sort(:by => :name).map { |t| { 
		:id => t.id, 
		:label => t.name, 
		:altnames => t.altnames, 
		:the => t.the,
		:permalink => t.permalink
	}}
end
