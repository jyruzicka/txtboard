require_relative "spec_helper"

class SampleClass
	include Txtboard::Property

	property :foo
	block_property :bar
end

describe Txtboard::Property do
	describe "#property" do
		it "should give us access to ivars using setter and getter methods" do
	    s = SampleClass.new
	    s.foo 3
	    expect(s.foo).to eq(3)
	  end  
	end

	describe "#block_property" do
	  it "should give us access to ivars using setter and getter methods" do
	    s = SampleClass.new
	    s.bar{ next 3 }
	    expect(s.bar[]).to eq(3)
	  end
	end
  
end