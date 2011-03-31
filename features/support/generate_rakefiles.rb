require 'erb'

class Group
  attr_reader :sources
  attr_reader :output
  attr_reader :minify

  def initialize(output, minify)
    @output = output
    @sources = []
    @minify = minify
  end
end

def groups
  @groups ||= {}
end

def add_to_groups(output, minify, file)
  groups[output] ||= Group.new(output, minify)
  groups[output].sources << file
end

def generate_rakefile
  template = <<-EOF
Rake::Minify.new do |conf|
  <% groups.values.each do |group| %>
  conf.add(<%= group.output %>, <%= group.minify %>, <%= group.sources.inspect %>)
  <% end %>
end
EOF
  erb = ERB.new(template)
  erb.result(binding)
end
