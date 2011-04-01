
class Rake::Minify
  class Group

    def initialize(&block)
      @sources = []

      instance_eval &block if block
    end

    def add(source, opts={:minify => true})
      @sources << Source.new(source, opts[:minify])
    end

    def build
      @sources.map { |s| s.build }.join("\n")
    end
  end
end
