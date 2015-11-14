Column.new "Active" do
	rank 2
	display :full

	conditions do |p|
		p.active? && !p.deferred?
	end

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