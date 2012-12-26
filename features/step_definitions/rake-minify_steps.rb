require 'fileutils'
require 'tmpdir'
require 'rake'

Given /^we want to add the file "([^"]*)" into "([^"]*)"$/ do |file, output|
  add_to_groups(output, file, nil)
end

Given /^we want to add the file "([^"]*)" into "([^"]*)" with options:$/ do |file, output, options|
  add_to_groups(output, file, options.rows_hash)
end

When /^I run rake minify$/ do
  run_task
end

Then /^"([^"]*)" should be minified$/ do |file|
  open(File.join(@dir, file)) do |result|
    open(File.join(File.dirname(__FILE__), "..", "js-expected", file)) do |expected|
      (result.read + "\n").should == expected.read
    end
  end
end

Then /^"([^"]*)" should include "([^"]*)"(?: and "([^"]*)")?$/ do |result, source1, source2|
  sources = [source1]
  sources << source2 if source2
  sources.map! do |s|
    file = File.join(File.dirname(__FILE__), "..", "js-expected", s)
    minified = true
    unless File.exists? file
      file = File.join(File.dirname(__FILE__), "..", "js-sources", s)
      minified = false
    end

    open(file) do |e|
      r = e.read
      r.gsub!(/\n$/, '') if minified
      r
    end
  end

  open(File.join(@dir, result)) do |result|
    content = result.read
    sources.each { |s| content.should include(s) }
  end
end

Given /^the basedir "([^"]*)"$/ do |dir|
  basedir(dir)
end

Given /^I have configured rake to minify at the "([^"]*)" command$/ do |name|
  @name_for_generation = name
end

When /^I run rake "([^"]*)"$/ do |task_name|
  run_task task_name
end

Given /^I have a "([^"]*)" rake task$/ do |arg1|
  pre << "task #{arg1} "
end

Given /^the inner directory "([^"]*)"$/ do |dir|
  indir(dir)
end

Given /^we want to add the following javascript into "(.*?)":$/ do |output, string|
  add_to_groups(output, nil, {}, string)
end
 
Given /^we want to add the following coffeescript into "(.*?)":$/ do |output, string|
  add_to_groups(output, nil, { :coffeescript => "true" }, string)
end

