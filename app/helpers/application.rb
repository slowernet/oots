def format_phone(p)
	p.gsub!(/\D/,'')
	"#{p[0..2]} #{p[3..5]} #{p[6..9]}"
end

def teams_for_select
	Team.all(:order => 'name').map { |t| { 
		:id => t.id, 
		:label => t.name, 
		:altnames => t.altnames, 
		:the => t.the,
		:permalink => t.permalink
	}}
end
