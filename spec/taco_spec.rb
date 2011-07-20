require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Taco do
  before(:all) do
    create_tacos
  end

  describe "attributes" do
    before(:each) do
      file    = File.join(tmp_dir, "/sample.taco")
      @taco   = Taco.parse_file(file)
    end

    it "should get name" do
      @taco.title.should == "Sample Taco"
    end

    it "should get description" do
      @taco.description.should include("This is a sample Taco.")
      @taco.description.should include("The description can be multilined.")
    end

    it "should get uri" do
      @taco.uri.should == "http://zachinglis.com/sample"
    end

    it "should get repository uri" do
      @taco.repository.should == "git://github.com/foo/bar.git"
    end
  end
end
