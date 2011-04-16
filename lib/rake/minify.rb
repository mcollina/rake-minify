require 'rake'
require 'rake/tasklib'
require 'jsmin'

class Rake::Minify < Rake::TaskLib

  autoload :Source, "rake/minify/source"
  autoload :Group, "rake/minify/group"

  def initialize(name=:minify, &block)
    @sources = {}
    @dir = nil
    @config = block

    desc "Minifies the specified javascripts" unless Rake.application.last_comment
    task name do
      invoke
    end
  end

  def add(output, source, opts = { :minify => true })
    @sources[build_path(output)] = Source.new(build_path(source), opts[:minify])
  end

  def group(output, &block)
    @sources[build_path(output)] = Group.new(self, &block)
  end

  def dir(dir, &block)
    @dir = dir
    block.call #FIXME @dir should be a stack
    @dir = nil
  end

  def invoke
    instance_eval &@config # to be configured like the pros

    @sources.each do |dest, source|
      Kernel.open(dest, "w") do |output|
        output << source.build
      end
    end
  end

  def build_path(file)
    @dir.nil? && file || File.join(@dir, file)
  end
end
