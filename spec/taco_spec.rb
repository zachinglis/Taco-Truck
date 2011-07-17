require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Taco" do
  # describe "#list" do
  #   before(:all) do
  #     create_test_environment
  #     @response = taco(:list)
  #   end
  #
  #   after(:all) do
  #     destroy_test_environment
  #   end
  #
  #   it "should explain what it's doing" do
  #     @response.should match(/Listing Tacos/)
  #   end
  #
  #   it "should find the name" do
  #     @response.should match(/Test Taco/)
  #   end
  #
  #   it "should find the description" do
  #     @response.should match(/This is a test Taco/)
  #   end
  #
  #   it "should find the URL" do
  #     @response.should match(/foobar.com/)
  #   end
  # end
  #
  # describe "#list" do
  #   before(:all) do
  #     create_test_environment(false)
  #     @response = taco(:list)
  #   end
  #
  #   after(:all) do
  #     destroy_test_environment
  #   end
  #
  #   it "should notify if there is no Tacos" do
  #     @response.should match(/No Tacos present/)
  #   end
  # end

  describe "#add" do
    before(:all) do
      create_test_environment
    end

    after(:all) do
      destroy_test_environment
    end

    it "should add Tacos" do
  pending
      lambda do
        taco(:add, "-u git://github.com/foo/bar")
      end.should change {
        taco(:list).lines.count
      }
    end

    it "should respond with an error if no argument is given" do
      taco(:add, "").should match(/Please provide all arguments/)
    end

    it "should only accept a valid git URI" do
      taco(:add, "-u http://notagitrepo.com").should match(/URI must be of a valid git repository/)
    end

    it "should parse the repository and extract the name, description and author" do
      pending
      # TacoTruck.should_receive(:parse_git).with("git://mockedrepo").and_return("daddy|Whos your daddy|daddy.com")
      # Thor::TacoTruck.expects(:add).returns('something')
      taco = taco(:add, "-u git://mockedrepo")
      # taco.should
    end
  end


  it "should not re-add a Taco if it exists"

end
