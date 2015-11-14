# Core methods to add to the txtboard itself
module Txtboard
	class << self
		# How high should the textboard be?
		attr_accessor :height

		# How wide should the textboard be?
		attr_accessor :width

		# Files location
		def location= l
			@location = l
			@config = nil
		end
		
		def location
			@location || File.join(ENV["HOME"], ".txtboard")
		end

		# Load data from our config file
		def config
			@config ||= begin
				file = File.join(self.location, "config.yaml")
				if File.exists?(file)
					YAML::load_file(file)
				else
					{}
				end
			end
		end

		# Determine basic dimensions
		def height
			@height || config["height"] || 0
		end

		def width
			@width || config["width"] || 80
		end

		# Set width - resets margin + column widths
		def width= w
			@width = w
			@column_width = nil
			@margin_width = nil
		end
		
		#---------------------------------------
		# Column stuff

		# Return all the columns the class knows about
		def columns
			@columns ||= Txtboard::Column.columns.sort_by(&:order)
		end

		# Basic column math
		def num_columns
			columns.size
		end

		def num_margins
			num_columns - 1
		end

		def margin_width
			@margin_width ||= begin
				mw = width % num_columns
				mw += num_columns until mw % num_margins == 0
				mw / num_margins
			end
		end

		def column_width
			@column_width ||= (width - margin_width) / num_columns
		end

		# Setup methods
		def set_column_widths!
			columns.each{ |c| c.width column_width }
		end

		def load_projects!(should_update: true)
			project_file = File.join(location, "db.yaml")
			if File.exists?(project_file)
				d = Rubyfocus::Document.load_from_file(project_file)
			else
				fetcher = if config["data"] == "remote"
					login_details = config["login_details"] || {}
					Rubyfocus::OSSFetcher.new(login_details["username"], login_details["password"])
				else
					Rubyfocus::LocalFetcher.new
				end
				d = Rubyfocus::Document.new(fetcher)
			end

			if should_update
				d.update
				d.save(project_file)
			end

			columns.each{ |c| c.add_projects_from d.projects }

		rescue Rubyfocus::OSSFetcherError => e
			puts "Something went wrong while fetching your OmniFocus file from the Omni Sync Server:"
			puts e.message
			puts "Please check your username and password."
			exit 1
		end

		# Printing and display
		def title
			("+" + "-"*(width-2) + "+").colour(:blue) + "\n" + 
			("|Kanban" + Time.now.strftime("%d %B, %Y|").rjust(width-7)).colour(:blue) + "\n" +
			("+" + "-"*(width-2) + "+").colour(:blue)
		end

		def column_heads
			columns.map(&:title).join(" "*margin_width) + "\n" +
			columns.map(&:title_underline).join(" "*margin_width)
		end

		def body
			board_height = columns.map(&:height).max
			board_height = [board_height, height].min if height

			str = (0...board_height).map do |i|
				columns.map{ |c| c.line(i) }.join(" "*margin_width)
			end
			str.join("\n")
		end
	end
end