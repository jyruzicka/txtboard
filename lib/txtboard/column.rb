class Txtboard::Column
	@columns = []
	class << self
		attr_accessor :columns
	end

	include Txtboard::Property
	# Column name. Displayed at head of column
	attr_accessor :name

	# Order of the column in the general board. Defaults to 0
	property :order

	# HOW...do you display your projects?
	property :display

	# Width of the column
	property :width

	# WHAT...are the conditions for projects in this column?
	block_property :conditions

	# HOW...do you sort your projects?
	block_property :sort

	# WHAT...colour are your projects?
	def colour(*args, &blck)
		if blck
			@colour = blck
		elsif args.size == 1
			@colour ? @colour[args.first] : 0
		elsif args.empty?
			@colour
		else
			raise ArgumentError, "wrong number of arguments (#{args.size} for 0,1)"
		end
	end

	##
	# Projects that will be displayed by this column
	attr_accessor :projects

	def initialize(name, &blck)
		# Initialize properties
	  @name = name

	  @order = 0
	  @display = :full
	  
	  @projects = []

		instance_exec(&blck) if block_given?
		Txtboard::Column.columns << self
	end

	def add_projects_from(project_array)
		@sorted_projects = nil
		@projects += if conditions
			project_array.select{ |p| conditions[p] }
		else
			project_array
		end
		@projects = @projects.uniq # Remove duplicates
	end

	def sorted_projects
		@sorted_projects ||= if sort
			if sort.arity == 1
				self.projects.sort_by(&sort)
			elsif sort.arity == 2
				self.projects.sort(&sort)
			else
				raise ArgumentError, "Attempting to sort projects, but sort block takes #{sort.arity} arguments."
			end
		else
			self.projects
		end
	end

	# Display properties
	def title
		if name.length > width
			name[0,width-3] + "..."
		else
			name.ljust(width)
		end
	end

	def title_underline
		("-" * [name.length,width].min).ljust(width)
	end

	def height
		body.size
	end

	def line(i)
		body[i]
	end

	def body
		@body ||= begin
			b = []
			sorted_projects.each do |p|
				project_colour = colour(p)
				b << divider(project_colour)
				b << justify(p.name, (p.flagged? ? "\\".colour(project_colour) : ""), project_colour)
				
				if display == :full
					# Number of tasks + indicator
					tasks = p.incomplete_tasks.size
					task_string = (tasks == 1 ? "1 task" : "#{tasks} tasks")

					# All unblocked, incomplete tasks
					next_tasks = p.next_tasks

					icon = if next_tasks.empty?
						"h"
					elsif next_tasks.all?{ |nt| nt.context.name == "Waiting for..." || nt.deferred? }
						if next_tasks.any?{ |nt| !nt.deferred? }
							"w"
						else
							first_start = next_tasks.map{ |t| t.start }.min
							days = ((first_start - Time.now) / (24 * 60 * 60)).to_i + 1
							"|#{days}"
						end
					else
						""
					end

					b << justify(task_string, icon, project_colour)
				end

				b << divider(project_colour)
			end
			b
		end
	end

	def divider(colour)
		("+" + "-"*(width-2) + "+").colour(colour)
	end

	def justify(ltext, rtext, colour)
		inner_width = width - 2 - rtext.colourless_size
		ltext = if (ltext.size > inner_width)
			ltext[0,inner_width-3] + "..."
		else
			ltext.ljust(inner_width)
		end
		"|".colour(colour) + ltext + rtext + "|".colour(colour)
	end
end