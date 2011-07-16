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
  run "./bin/taco #{method.to_s} #{args}"
end

def run(command)
  result = `#{command}`
  # [result, $?.success?] May be overkill for what I need. We'll see.
  result
end
