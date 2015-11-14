module Txtboard
	def self.setup(dir)
		FileUtils::mkdir_p dir
		FileUtils::mkdir_p File.join(dir, "columns")

		File.open(File.join(dir, "columns/backburner.rb"), "w") do |io|
			io.puts <<-EOF
Txtboard::Column.new "Backburner" do
	order 1
	display :compact

	conditions{ |p| p.on_hold? || p.deferred? }
end
			EOF
		end

		File.open(File.join(dir, "columns/active.rb"), "w") do |io|
			io.puts <<-EOF
Txtboard::Column.new "Active" do
	order 2
	display :full

	conditions{ |p| p.active? && !p.deferred? }

	sort do |p|
		case true
		when p.flagged?
			0
		when (p.actionable_tasks.any?{ |t| t.context.name != "Waiting for..."}) # When there any actionable task which isn't waiting on
			1
		else
			2
		end
	end

	colour do |p|
		case true
		when p.flagged?
			31
		when (p.actionable_tasks.any?{ |t| t.context.name != "Waiting for..."})
			0
		else
			33
		end
	end

end
			EOF
		end

		File.open(File.join(dir, "columns/complete.rb"), "w") do |io|
			io.puts <<-EOF
Txtboard::Column.new "Completed" do
	order 3
	display :compact

	conditions(&:completed?)
end
			EOF
		end

		File.open(File.join(dir, "config.yaml"),"w") do |io|
			io.puts <<-EOF
---
height: 30
width: 80

# To enable Omni Sync Server, comment out the first line below, and uncomment
# the following. Then add your own username and password.
data: local
# data: remote
# login_details:
#   username: MyUsername
#   password: MyPassword
			EOF
		end
	end
end