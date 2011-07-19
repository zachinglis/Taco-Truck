require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# TODO: turn match into include (as a string)
# Remember to use
# Thor::Actions
# TODO: Serialize data properly

describe TacoTruck do
  describe "#list" do
    before(:all) do
      create_test_environment
      @response = taco(:list)
    end

    after(:all) do
      destroy_test_environment
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

  describe "#list" do
    before(:all) do
      create_test_environment(false)
      @response = taco(:list)
    end

    after(:all) do
      destroy_test_environment
    end

    it "should notify if there is no Tacos" do
      @response.should match(/No Tacos present/)
    end
  end

  describe "#add" do
    before(:all) do
      create_test_environment
    end

    after(:all) do
      destroy_test_environment
    end

    it "should add Tacos" do
      lambda do
        taco(:add, { :uri => "git://github.com/foo/bar.git" })
      end.should change {
        taco(:list).lines.count
      }
    end

    it "should respond with an error if no argument is given" do
      lambda do
        taco(:add)
      end.should raise_error(/Please provide all arguments/)
    end

    it "should only accept a valid git URI" do
      lambda do
        taco(:add, :uri => "http://notagitrepo.com")
      end.should raise_error(/URI must be of a valid git repository/)
    end

    it "should parse the repository and extract the name, description and author" do
      TacoTruck.should_receive(:parse_git).with("git://mockedrepo").and_return(["Mocked Taco", "It works", "http://itworks.com"])
      taco(:add, :uri => "git://mockedrepo")
      taco(:list).should include("Mocked Taco")
    end

    it "should not re-add a Taco if it exists" do
      TacoTruck.should_receive(:parse_git).with("git://doublysubmitted").twice.and_return(["Doubly Submitted", "It works alos", "http://itworks.com/labs/second"])
      taco(:add, :uri => "git://doublysubmitted")

      lambda do
        taco(:add, :uri => "git://doublysubmitted")
      end.should_not change {
        taco(:list).lines.count
      }
    end

  end

  describe ".git_name_from_repo" do
    it "should bail gracefully" do
      lambda do
        TacoTruck.git_name_from_repo("garbledurl")
      end.should raise_error
    end

    it "should find the correct name from a URL" do
      TacoTruck.git_name_from_repo("git://github.com/clinteastwood/dirtyharry.github").should eql("dirtyharry")
    end
  end

  # TODO: Test parse_git
end
