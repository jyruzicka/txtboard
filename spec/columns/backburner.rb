Column.new "Backburner" do
	order 1
	display :compact

	conditions do |p|
		p.on_hold? || p.deferred?
	end
end