require_relative "spec_helper"

describe Txtboard::Column do
  describe "#initialize" do
    it "should initialize with default values" do
      c = Txtboard::Column.new("Sample column")
      expect(c.name).to eq("Sample column")
      expect(c.display).to eq(:full)
      expect(c.order).to eq(0)
    end

    it "should allow us to provide it a block" do
      c = Txtboard::Column.new("Not my name"){ self.name = "This is my name" }
      expect(c.name).to eq("This is my name")
    end
  end

  describe "#order" do
    it "should allow us to set and retrieve column's order" do
   		c = Txtboard::Column.new("Sample column"){ order 1 } 
   		expect(c.order).to eq(1)  
    end
  end

  describe "#display" do
    it "should allow us to set and retrieve display" do
      c = Txtboard::Column.new("Sample column"){ display :compact }
      expect(c.display).to eq(:compact)
    end
  end

  describe "#conditions" do
    it "should set and retrieve a block" do
      c = Txtboard::Column.new("Sample column"){ conditions { true } }
      expect(c.conditions[]).to eq(true)
    end
  end

  describe "#sort" do
    it "should set and retrieve a block" do
      c = Txtboard::Column.new("Sample column"){ sort { true } }
      expect(c.sort[]).to eq(true)
    end
  end

  describe "#colour" do
    it "should set and retrieve a block" do
      c = Txtboard::Column.new("Sample column"){ colour { true } }
      expect(c.colour[]).to eq(true)
    end

    it "should run on an object when required" do
      c = Txtboard::Column.new("Colour column"){ colour{ |i| i % 3 }}
      expect(c.colour(4)).to eq(1)
    end
  end

  describe "#add_projects_from" do
    it "should add all projects if no conditions are given" do
      c = Txtboard::Column.new("Sample column")
      c.add_projects_from [1,2,3,4,5]
      expect(c.projects.size).to eq(5)
    end

    it "should only add projects which fulfil the block if conditions are given" do
      c = Txtboard::Column.new("Even column"){ conditions { |i| i % 2 == 0 } }
      c.add_projects_from [1,2,3,4,5]
      expect(c.projects).to eq([2,4])
    end
  end

  describe "#sorted_projects" do
    it "should function perfectly when no sorting algorithm is given" do
      c = Txtboard::Column.new("Unsorted column")
      c.add_projects_from [1,2,3,4,5]
      expect(c.sorted_projects.size).to eq(5)
    end

    it "should properly sort using sort_by when one-arg sort is provided" do
      c = Txtboard::Column.new("Sorted using sort_by") do
        sort{ |i| i % 2 }
      end
      c.add_projects_from [1,2,3,4,5]

      sp = c.sorted_projects
      expect(sp.index(2)).to be < sp.index(3)
      expect(sp.index(4)).to be < sp.index(3)
    end

    it "should properly sort using sort when two-arg sort is provided" do
      c = Txtboard::Column.new("Sorted using sort_by") do
        sort{ |a,b| a == 5 ? -1 : (b == 5 ? 1 : 0) }
      end

      c.add_projects_from [1,2,3,4,5]

      sp = c.sorted_projects
      expect(sp.index(5)).to eq(0)
    end
  end

  # Display stuff
  describe "#width" do
    it "should set and get width" do
      c = Txtboard::Column.new("Sample column")
      c.width 80
      expect(c.width).to eq(80)
    end
  end

  describe "#title" do
    it "should justify the name on title based on width" do
      c = Txtboard::Column.new("Sample column"){ width 20 }
      expect(c.title).to eq("Sample column       ")
      c.width 9
      expect(c.title).to eq("Sample...")
    end
  end

  describe "#title_underline" do
    it "should set the correct underline width" do
      c = Txtboard::Column.new("Sample column"){ width 20 }
      expect(c.title_underline).to eq("-------------       ")
      c.width 9
      expect(c.title_underline).to eq("---------")
    end
  end
end