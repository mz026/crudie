$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "crudify/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "crudify"
  s.version     = Crudify::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Crudify."
  s.description = "TODO: Description of Crudify."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.8"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
