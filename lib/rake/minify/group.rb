
class Rake::Minify
  class Group
    attr_reader :parent

    def initialize(parent, &block)
      @sources = []
      @parent = parent

      instance_eval &block if block
    end

    def add(*args, &block)
      if block
        source = block
      else
        source = parent.build_path(args.shift)
      end

      opts = args.shift
      opts ||= { :minify => true }

      @sources << Source.new(source, opts)
    end

    def build
      @sources.map { |s| s.build }.join("\n")
    end

    def dir(dir, &block)
      parent.dir(dir, &block)
    end
  end
end
