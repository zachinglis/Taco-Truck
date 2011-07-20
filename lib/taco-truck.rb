require "thor"
require "yaml"
require "taco"
## Todo: Don't forget say_status, etc

class TacoTruck < Thor
  include Thor::Actions

  add_runtime_options!

  class_option :environment, :type => :string, :aliases => "-e"

  desc "install", "Install the Tacofiles"
  def install
    unless File.directory?(taco_dir)
      Dir.mkdir(taco_dir)
      File.open(taco_file, "w")
    end
  end

  desc "add", "Register a git URI"
  method_option :uri,     :type => :string, :aliases => "-u"
  def add
    puts "Registering..."

    raise "Error: Please provide all arguments" if options[:uri].nil?
    raise "Error: URI must be of a valid git repository" unless options[:uri].match(/^git:\/\//)

    append_file taco_file, "\n#{parse_git(options[:uri]).join("|")}"

    puts "Registered!"
  end

  desc "list", "List all registered Tacos"
  def list
    puts "Listing Tacos..."
    file = File.read(taco_file)
    file.each_line do |line|
      attributes = line.split("|")
      puts attributes.join("  |  ")
    end
    puts "No Tacos present" if file == ""
  end

protected
  def parse_git(uri)
    # TODO: For now, actually grabbing git needs to be done but is more complex, so pointing to the Github file will suffice for now.
    parse_git_file(uri)
    ["Yay", "It Works", "It really works"]
  end

  def parse_git_file(uri)
    inside(taco_tmp_dir) do
      clone = run "git clone #{uri}"
    end
  end

  GIT_NAME_FROM_URL = /git:\/\/.*.\/(.*).git/
  def self.git_name_from_repo(uri)
    match = uri.match(GIT_NAME_FROM_URL)
    if match.nil?
      raise "Please provide a valid git URI"
    else
      match[1]
    end
  end

  def taco_dir
    if options[:environment] == "test"
      File.join(Dir.pwd, "spec/fixtures/taco")
    else
      File.join(File.expand_path("~"), ".taco")
    end
  end

  def taco_file
    [taco_dir, "tacofile"].join("/")
  end

  def taco_tmp_dir
    [taco_dir, "tmp"].join("/")
  end
end
