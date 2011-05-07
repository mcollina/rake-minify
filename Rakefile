require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rake-minify"
  gem.homepage = "http://github.com/mcollina/rake-minify"
  gem.license = "MIT"
  gem.summary = %Q{A rake task to minify javascripts and coffeescripts}
  gem.description = %Q{A rake task to minify javascripts and coffeescripts}
  gem.email = "matteo.collina@gmail.com"
  gem.authors = ["Matteo Collina"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
  gem.add_dependency "jsmin", "~> 1.0.1"
  gem.add_development_dependency "rspec", "~> 2.5.0"
  gem.add_development_dependency "cucumber", ">= 0"
  gem.add_development_dependency "jeweler", "~> 1.5.2"
  gem.add_development_dependency 'test_notifier', '~> 0.3.6'
  gem.add_development_dependency 'autotest', '~> 4.4'
  gem.add_development_dependency "rcov", ">= 0"
  gem.add_development_dependency "coffee-script", ">= 2.2.0"
end
Jeweler::RubygemsDotOrgTasks.new

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

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rake-minify #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
