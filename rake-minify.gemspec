# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "rake-minify"
  gem.version       = File.read "VERSION"
  gem.authors       = ["Matteo Collina"]
  gem.email         = ["hello@matteocollina.com"]
  gem.description   = %q{A rake task to minify javascripts and coffeescripts}
  gem.summary       = %q{A rake task to minify javascripts and coffeescripts}
  gem.homepage      = "http://github.com/mcollina/rake-minify"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("rake", ">= 0.8.7")
  gem.add_dependency("jsmin", "~> 1.0.1")

  gem.add_development_dependency("rspec", "~> 2.12.0")
  gem.add_development_dependency("cucumber", ">= 0")
  gem.add_development_dependency('test_notifier', '~> 0.3.6')
  gem.add_development_dependency('autotest', '~> 4.4')

  if RUBY_VERSION >= "1.9"
    gem.add_development_dependency("simplecov")
  end

  gem.add_development_dependency("coffee-script", ">= 2.2.0")
  gem.add_development_dependency("therubyracer")
end
