require 'erb'
require 'fileutils'
require 'tmpdir'
require 'rake'

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

Given /^we want to minify the js file "([^"]*)" into "([^"]*)"$/ do |file, output|
  add_to_groups(output, true, file)
end

When /^I run rake minify$/ do
  @dir = Dir.mktmpdir
  FileUtils.cp_r(File.join(File.dirname(__FILE__), "..", "js-sources"), @dir)
  rakefile = File.join(@dir, "Rakefile")
  open(rakefile, "w") { |io| io << generate_rakefile }
  
  application = Rake::Application.new
  Rake.application = application
  application.add_import(rakefile)
  application.load_imports
  application["minify"].invoke
end

Then /^"([^"]*)" should be minified$/ do |file|
  open(File.join(@dir, file)) do |result|
    open(File.join(File.dirname(__FILE__), "..", "js-expected", file)) do |expected|
      result.read.should == exptected.read
    end
  end
end

Given /^we want to combine the js file "([^"]*)" into "([^"]*)"$/ do |file, output|
  add_to_groups(output, false, file)
end

Then /^"([^"]*)" should include "([^"]*)" and "([^"]*)"$/ do |result, source1, source2|
  expected = ""
  [source1, source2].each do |s|
    file = File.join(File.dirname(__FILE__), "..", "js-expected", s)
    unless File.exists? file
      file = File.join(File.dirname(__FILE__), "..", "js-sources", s)
    end

    open(file) do |e|
      expected << e.read
    end
  end

  open(File.join(@dir, result)) do |result|
    result.read.should == expected
  end
end

