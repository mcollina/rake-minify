require 'erb'

class Group
  attr_reader :sources
  attr_reader :output

  def initialize(output)
    @output = output
    @sources = []
  end

  def add(source, minify)
    @sources << GroupElement.new(source, minify)
  end
end

GroupElement = Struct.new(:source, :minify)

def groups
  @groups ||= Hash.new do |h, k|
    h[k] = Group.new(k)
  end
end

def add_to_groups(output, minify, file)
  groups[output].add(file, minify)
end

def generate_rakefile
  template = <<-EOF
<%= pre.join("\n") %>

Rake::Minify.new(<%= @name_for_generation %>) do
  <% if basedir.size > 0 %>
  dir(File.join(File.dirname(__FILE__), <%= basedir.inspect %>)) do
  <% end %> 
    <% groups.values.each do |group| %>
      <% if group.sources.size == 1 %>
        add(<%= group.output.inspect %>, <%= group.sources.first.source.inspect %>)
      <% else %>
        group(<%= group.output.inspect %>) do |group|
          <% group.sources.each do |element| %>
            add(<%= element.source.inspect %>, :minify => <%= element.minify %>)
          <% end %>
        end
      <% end %>
    <% end %>
  <% if basedir.size > 0 %>
  end
  <% end %> 
end
EOF
  erb = ERB.new(template)
  erb.result(binding)
end

def basedir(dir="")
  @basedir ||= dir
end

def run_task(task_name="minify")
  @dir = Dir.mktmpdir
  FileUtils.mkdir File.join(@dir, basedir) if basedir.size > 0
  Dir.glob(File.join(File.dirname(__FILE__), "..", "js-sources", "*")) do |file|
    FileUtils.cp(file, File.join(@dir, basedir))
  end
  rakefile = File.join(@dir, "Rakefile")
  open(rakefile, "w") { |io| io << generate_rakefile }
  
  application = Rake::Application.new
  Rake.application = application
  application.add_import(rakefile)
  application.load_imports
  FileUtils.cd(@dir) do
    application[task_name].invoke
  end
end

def pre
  @pre ||= []
end
