class String
	COLOURS = {
		black:  30,
		red:    31,
		dark:   32,
		brown:  33,
		purple: 34,
		pink:   35,
		blue:   36,
		yellow: 37
	}

	# Size, not including unprintable colour characters
	def colourless_size
		self.gsub(/\033\[\d+m/,"").size
	end

	# Colour a string a particular colour
	def colour(colour)
		colour = COLOURS[colour] if colour.is_a?(Symbol)
		"\033[#{colour}m#{self}\033[0m"
	end
end