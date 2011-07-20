require 'simplecov'
SimpleCov.start 'rails'

require 'spork'

SimpleCov.start

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  require 'rspec'
  require 'taco-truck'

  # Requires supporting files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories.
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

  RSpec.configure do |config|
  end
end

Spork.each_run do
  def in_temporary_folder(&block)
    Dir.chdir("#{File.dirname(__FILE__)}/tmp") do
      block.call
    end
  end

  def taco(method, args={})
    args.merge!({
      :environment => "test"
    })
    args_array = args.collect { |key, value| ["--#{key}", value] }.flatten

    capture do
      TacoTruck.start(Array(method) + args_array)
    end
  end

  def run(command)
    result = `#{command}`
    # [result, $?.success?] May be overkill for what I need. We'll see.
    result
  end

  def fixtures_dir
    File.join(Dir.pwd, "spec/fixtures")
  end

  def taco_tmp_dir
    File.join(Dir.pwd, "spec/tmp")
  end

  def taco_dir
    File.join(taco_tmp_dir, "/taco")
  end

  def create_test_environment(fixtures=true)
    destroy_test_environment
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

  def create_tacos
    %w(sample).each do |name|
      FileUtils.cp(File.join(fixtures_dir, "/#{name}.taco"), File.join(taco_tmp_dir, "/#{name}.taco"))
    end
  end

  def capture(stream=:stdout)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end
