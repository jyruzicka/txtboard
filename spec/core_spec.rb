require_relative "spec_helper"

describe Txtboard do
	describe "#location" do
	  it "should default to ~/.txtboard" do
	    expect(Txtboard.location).to eq(File.join(ENV["HOME"], ".txtboard"))
	  end
	end

	describe "#config" do
	  it "should load a hash from the config file" do
	    Txtboard.location = File.join(__dir__, "files")
	    expect(Txtboard.config["foo"]).to eq("bar")
	  end

	  it "should load {} if the file doesn't exist" do
	  	Txtboard.location = __dir__
	    expect(Txtboard.config).to eq({})
	  end
	end

	describe "#height" do
	  it "should default to 0" do
	    Txtboard.location = __dir__
	    expect(Txtboard.height).to eq(0)
	  end

	  it "should otherwise default to config value" do
	    Txtboard.location = File.join(__dir__, "files")
	    expect(Txtboard.height).to eq(100)
	  end
	end

	describe "#width" do
	  it "should default to 80" do
	    expect(Txtboard.width).to eq(80)
	  end
	end

	describe "columns" do
	  before(:all) do
	  	Txtboard::Column.columns = []
	  	Txtboard::Column.new("Second column"){ order 2 }
	  	Txtboard::Column.new("First column") { order 1 }
	  end

	  describe "#columns" do
	    it "should pass back all columns, properly ordered" do
	      expect(Txtboard.columns.size).to eq(2)
	      expect(Txtboard.num_columns).to eq(2)
	      expect(Txtboard.num_margins).to eq(1)
	      expect(Txtboard.columns.first.name).to eq("First column")
	    end
	  end

	  describe "#margin_width" do
	    it "should determine margin width correctly based on number of columns" do
	      Txtboard.width = 50
	      expect(Txtboard.margin_width).to eq(0)
	      expect(Txtboard.column_width).to eq(25)

	      Txtboard.width = 49
				expect(Txtboard.margin_width).to eq(1)
	      expect(Txtboard.column_width).to eq(24)	      
	    end
	  end
	end
  
end