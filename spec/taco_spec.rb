require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Taco" do
  describe "#list" do
    before(:all) do
      @response = taco(:list)
    end

    it "should explain what it's doing" do
      @response.should match(/Listing Tacos/)
    end

    it "should find the name" do
      @response.should match(/Test Taco/)
    end

    it "should find the description" do
      @response.should match(/This is a test Taco/)
    end

    it "should find the URL" do
      @response.should match(/foobar.com/)
    end
  end

  it "can add Tacos" do
    lambda do
      taco(:add, "-u git://github.com/foo/bar")
    end.should change {
      taco(:list).lines.count
    }
  end
  
  it "should not re-add a Taco if it exists"

end
