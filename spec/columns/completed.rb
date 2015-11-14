Column.new "Completed" do
	rank 3
	display :compact

	conditions(&:completed?)
end