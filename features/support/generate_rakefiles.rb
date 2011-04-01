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
Rake::Minify.new do
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
