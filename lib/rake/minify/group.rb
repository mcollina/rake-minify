
class Rake::Minify
  class Group
    attr_reader :parent

    def initialize(parent, &block)
      @sources = []
      @parent = parent

      instance_eval &block if block
    end

    def add(source, opts=nil)
      opts ||= { :minify => true }
      @sources << Source.new(parent.build_path(source), opts)
    end

    def build
      @sources.map { |s| s.build }.join("\n")
    end

    def dir(dir, &block)
      parent.dir(dir, &block)
    end
  end
end
