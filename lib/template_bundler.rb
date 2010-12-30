module TemplateBundler
	module ViewHelper
		def include_templates(dir)
			Dir.glob(File.join(dir, "**/_*.html.erb")).map do |f|
				id = File.dirname(f).split('/').pop + '-' + File.basename(f, '.html.erb').downcase.sub(/^_/, '').gsub('_','-').gsub(/[^a-z-]/,'')
				"<script type='text/html' class='template' id='#{id}'>#{File.read(f)}</script>"
			end.join
		end	
	end
end