$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "geoincident/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "geoincident"
  s.version     = Geoincident::VERSION
  s.authors     = ["Tasos Latsas"]
  s.email       = ["tlatsas2000@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Geoincident."
  s.description = "TODO: Description of Geoincident."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.8"

  s.add_development_dependency "sqlite3"
end
