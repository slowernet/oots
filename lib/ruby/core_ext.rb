class String

	def titleize
		self.gsub(/\b(.)/){ $1.upcase }.gsub(/('.)/){ $1.downcase }.to_s
	end
	
	def dasherize
		self.gsub("'", '').parameterize.to_s
	end

end

class Hash
	
	def recursive_merge(h)
		self.merge!(h) { |key, _old, _new| if _old.class == Hash then _old.recursive_merge(_new) else _new end } 
	end
	
end