$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "crudie/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "crudie"
  s.version     = Crudie::VERSION
  s.authors     = ["Yang-Hsing Lin"]
  s.email       = ["yanghsing.lin@gmail.com"]
  s.homepage    = ""
  s.summary     = "A rails plugin to abstract CRUD api in controller"
  s.description = "A rails plugin to abstract CRUD api in controller"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 4.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'rspec_api_documentation'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'jbuilder'
end
