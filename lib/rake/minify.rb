require 'rake'
require 'rake/tasklib'
require 'jsmin'

class Rake::Minify < Rake::TaskLib

  autoload :Source, "rake/minify/source"
  autoload :Group, "rake/minify/group"

  def initialize(&block)
    @sources = {}

    instance_eval &block # to be configured like the pros

    task "minify" do
      invoke
    end
  end

  def add(output, source, opts = { :minify => true })
    @sources[output] = Source.new(source, opts[:minify])
  end

  def group(output, &block)
    @sources[output] = Group.new &block
  end

  def invoke
    @sources.each do |dest, source|
      Kernel.open(dest, "w") do |output|
        output << source.build
      end
    end
  end
end
