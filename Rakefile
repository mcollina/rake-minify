require "bundler/gem_tasks"

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
  spec.rcov_opts = ["--text-summary", "--exclude","lib\/rspec,bin\/rspec,lib\/rcov," + 
             "spec,diff-lcs,lib\/cucumber,lib\/gherkin,cucumber,features,rake-0,coffee,json,execjs,jsmin"]

end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => [:features, :spec]

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rake-minify #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
