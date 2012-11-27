helpers do
	def config_to_json
		$config.select { |k,v| [:base_url].include?(k) }.to_json
	end
	
	def body_class
		# hack dependent on Tilt internals
		begin
			template_cache.instance_variable_get(:@cache).keys.first[1].to_s.sub(/\..*$/,'').split("/").join(' ')
		rescue
		end
	end
	
	def format_phone(p)
		unless p.blank?
			p.gsub!(/\D/,'')
			"#{p[0..2]} #{p[3..5]} #{p[6..9]}"
		end
	end

	def teams_for_select
		Team.all.sort(:by => :name).map { |t| { 
			:id => t.id, 
			:label => t.name, 
			# :altnames => t.altnames, 
			:the => t.the,
			:permalink => t.permalink
		}}
	end
end