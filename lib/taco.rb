# require 'ftools' # depends on 1.8.7 or 1.9 - need to clean these declerations up
require 'fileutils'

# I originally used meta-programming for the attributes but it led to too much issues. I could restyle this to be better programmed but I prefer the format it gives.
class Taco
  def initialize
    @attributes = {}
    @hooks      = {}
  end

  def title(arg=nil)
    if arg.nil?
      @attributes[:title]
    else
      @attributes[:title] = arg
    end
  end

  def description(arg=nil)
    if arg.nil?
      @attributes[:description]
    else
      @attributes[:description] = arg
    end
  end

  def repository(arg=nil)
    if arg.nil?
      @attributes[:repository]
    else
      @attributes[:repository] = arg
    end
  end

  def uri(arg=nil)
    if arg.nil?
      @attributes[:uri]
    else
      @attributes[:uri] = arg
    end
  end

  # Call with instance.call
  def install(&block)
    if block_given?
      @attributes[:install] = block
    else
      @attributes[:install]
    end
  end

  def after_install(&block)
    if block_given?
      @attributes[:install] = block
    else
      @attributes[:install]
    end
  end

  def self.describe(&block)
    taco = Taco.new
    taco.instance_eval &block
    taco
  end

  def self.parse_file(file)
    file = File.read(file)
    eval(file)
  end
end
