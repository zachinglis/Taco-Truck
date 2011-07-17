$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'taco-truck'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  # ...
end

def in_temporary_folder(&block)
  Dir.chdir("#{File.dirname(__FILE__)}/tmp") do
    block.call
  end
end

def taco(method, args="")
  run "ENV TACO_ENV=test ./bin/taco #{method.to_s} #{args}"
end

def run(command)
  result = `#{command}`
  # [result, $?.success?] May be overkill for what I need. We'll see.
  result
end

def taco_dir
  File.join(Dir.pwd, "spec/fixtures/taco")
end

def create_test_environment(fixtures=true)
  Dir.mkdir(taco_dir)
  File.open(File.join(taco_dir, "tacofile"), "w+") do |file|
    if fixtures == true
      file.write "Test Taco|This is a test Taco|http://foobar.com\nAnother Taco|This is yet another Taco|http://foo.com"
    end
  end
end

def destroy_test_environment
  `rm -rf #{taco_dir}`
end
