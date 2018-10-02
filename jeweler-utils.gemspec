$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "jeweler/utils/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jeweler-utils"
  s.version     = Jeweler::Utils::VERSION
  s.authors     = ["Vas Kaloidis"]
  s.email       = ["vas.kaloidis@gmail.com"]
  s.homepage    = "http://www.bluehelmet.software"
  s.summary     = "Helper and Utility methods for Jeweler, Jeweler::Utils."
  s.description = "Desc Jeweler::Utils"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_development_dependency "sqlite3"
  s.add_dependency(%q<activerecord>.freeze, [">= 4.2.6"])
  s.add_dependency(%q<actionpack>.freeze, [">= 4.2.6"])
  s.add_dependency(%q<virtus>.freeze, [">= 0"])
  s.add_dependency("rails", [">= 5.2.0"])
end
