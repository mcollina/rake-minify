require 'rake'
require 'rake/tasklib'
require 'jsmin'

class Rake::Minify < Rake::TaskLib

  def initialize(&block)
    #@sources = Hash.new { |h, k| h[k] = [] }
    @sources = {}

    instance_eval &block # to be configured like the pros

    task "minify" do
      invoke
    end
  end

  def add(output, source, opts = { :minify => true })
    @sources[output] = Source.new(source, opts[:minify])
  end

  def invoke
    @sources.each do |dest, source|
      Kernel.open(dest, "w") do |output|
        output << source.build
      end
    end
  end

  class Source
    attr_reader :source, :minify

    def initialize(source, minify)
      @source = source
      @minify = minify
    end

    def build
      Kernel.open(source) do |input|
        minify && JSMin.minify(input.read) || input.read
      end
    end
  end
end
