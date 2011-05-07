class Rake::Minify::Source
  attr_reader :source, :minify

  def initialize(source, options=nil)
    options ||= {}
    @source = source
    @minify = optional_boolean(options[:minify], true)
    @coffee_bare = optional_boolean(options[:bare], false)
  end

  def build
    coffee_script! if coffee?

    Kernel.open(source) do |input|
      output = input.read
      output = CoffeeScript.compile(output, :bare => @coffee_bare) if coffee?
      output = JSMin.minify(output).strip if minify 
      output
    end
  end

  def coffee?
    source =~ /\.coffee$/
  end

  private
  def coffee_script!
    begin
      require 'coffee-script'
    rescue
      raise "Missing coffee-script gem"
    end
  end

  def optional_boolean(value, default)
    return true if value
    return default if value.nil?
    value
  end
end
