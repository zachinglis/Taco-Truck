require "thor"
require "yaml"

class TacoTruck < Thor
  include Thor::Actions

  class_option :environment, :type => :string, :aliases => "-e"

  # ./bin/taco hello --who yous -m "How are you?"
  desc "hello", "A Hello World method for debugging"
  method_option :who,     :type => :string, :aliases => "-w"
  method_option :message, :type => :string, :aliases => "-m"
  def hello
    puts "Hello #{options[:who]}!!"
    unless options[:message].nil?
      puts "Also, #{options[:message]}"
    end
  end

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
    return puts "Error: Please provide all arguments" if options[:uri].nil?
    return puts "Error: URI must be of a valid git repository" unless options[:uri].match(/^git:\/\//)

    File.open(taco_file, "a") do |file|
      file.write("\n" + TacoTruck.parse_git(options[:uri]).join("|"))
    end

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
  def self.parse_git(uri)
    # TODO: For now, actually grabbing git needs to be done but is more complex, so pointing to the Github file will suffice for now.
    
    ["Yay", "It Works", "It really works"]
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
end
