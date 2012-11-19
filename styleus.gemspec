$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "styleus/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'styleus'
  s.version     = Styleus::VERSION
  s.authors     = ['Falk Hoppe']
  s.email       = ['falkhoppe81@googlemail.com']
  #s.homepage    = "TODO"
  s.summary     = 'Styleguide Support Tool'
  s.description = 'styleus is a support tool for creating a fast and simple component based html style guide.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']
  #s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 3.2.9'
  s.add_runtime_dependency 'coderay'
  s.add_development_dependency 'compass-rails'
end
