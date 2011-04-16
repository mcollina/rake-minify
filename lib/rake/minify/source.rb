class Rake::Minify::Source
  attr_reader :source, :minify

  def initialize(source, minify)
    @source = source
    @minify = minify
  end

  def build
    coffee_script! if coffee?

    Kernel.open(source) do |input|
      output = input.read
      output = CoffeeScript.compile(output, :bare => true) if coffee? #TODO make bare configurable
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
      exit 1
    end
  end
end
