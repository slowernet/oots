class String

	def titleize
		self.gsub(/\b(.)/){ $1.upcase }.gsub(/('.)/){ $1.downcase }.to_s
	end
	
	def dasherize
		self.gsub("'", '').parameterize.to_s
	end

end

