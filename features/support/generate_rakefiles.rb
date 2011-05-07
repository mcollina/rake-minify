require 'erb'

class Group
  attr_reader :sources
  attr_reader :output

  def initialize(output)
    @output = output
    @sources = []
  end

  def add(source, options)
    @sources << GroupElement.new(source, options)
  end
end

GroupElement = Struct.new(:source, :options)

def groups
  @groups ||= Hash.new do |h, k|
    h[k] = Group.new(k)
  end
end

def add_to_groups(output, file, options=nil)
  options = options.keys.reduce({}) do |hash, key|
    hash[key.to_sym] = eval(options[key])
    hash
  end if options
  groups[output].add(file, options)
end

def generate_rakefile
  template = <<-EOF
<%= pre.join("\n") %>

Rake::Minify.new(<%= @name_for_generation %>) do
  <% if basedir %>
  dir(<%= basedir.inspect %>) do
  <% end %> 
    <% groups.values.each do |group| %>
      <% if group.sources.size == 1 %>
        add(<%= group.output.inspect %>, <%= group.sources.first.source.inspect %>, <%= group.sources.first.options.inspect %>)
      <% else %>
        group(<%= group.output.inspect %>) do |group|
          <% if indir %>
            dir(<%= indir.inspect %>) do
          <% end %> 
          <% group.sources.each do |element| %>
            add(<%= element.source.inspect %>, <%= element.options.inspect %>)
          <% end %>
          <% if indir %>
            end
          <% end %> 
        end
      <% end %>
    <% end %>
  <% if basedir %>
  end
  <% end %> 
end
EOF
  erb = ERB.new(template)
  erb.result(binding)
end

def basedir(dir=nil)
  @basedir ||= dir
end

def indir(dir=nil)
  @indir ||= dir
end

def run_task(task_name="minify")
  @dir = Dir.mktmpdir
  dest_dir = File.join(*([basedir, indir, ""].select { |e| e }))
  FileUtils.mkdir_p File.join(@dir, dest_dir) if dest_dir.size > 0
  Dir.glob(File.join(File.dirname(__FILE__), "..", "js-sources", "*")) do |file|
    FileUtils.cp(file, File.join(@dir, dest_dir))
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
