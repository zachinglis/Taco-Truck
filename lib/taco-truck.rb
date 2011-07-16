require "thor"
require "yaml"

class TacoTruck < Thor
  include Thor::Actions

  # ./bin/taco hello --who yous -m "How are you?"
  desc "hello", "A Hello World method for debugging"
  method_option :who, :type => :string, :aliases => "-s"
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
  method_option :uri, :type => :string, :aliases => "-u"
  def add
    puts "Registering..."
    File.open(taco_file, "a") do |file|
      file.write("\ntest|foo|bar")
    end
    puts "Registered!"
  end

  desc "list", "List all registered Tacos"
  def list
    puts "Listing Tacos..."
    file = File.read(taco_file)
    file.each_line do |line|
      attributes = line.split("|")
      puts "#{attributes[0]}  |  #{attributes[1]}  |  #{attributes[2]}"
    end
  end

protected
  def taco_dir
    RUBY_PLATFORM =~ /win32/ ? win32_cache_dir : File.join(File.expand_path("~"), ".taco")
  end

  def taco_file
    [taco_dir, "tacofile"].join("/")
  end
end
