require "bundler/gem_tasks"

require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new

namespace :spec do
  desc "Create rspec coverage"
  task :coverage do
    ENV['COVERAGE'] = 'true'
    Rake::Task["spec"].execute
  end
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => [:features, :spec]

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  require "rake/minify"
  version = Rake::Minify::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rake-minify #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
