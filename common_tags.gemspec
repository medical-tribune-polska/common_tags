$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'common_tags/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'common_tags'
  s.version     = CommonTags::VERSION
  s.authors     = ['Azat Galikhanov']
  s.email       = ['a.galikhanov@medical-tribune.pl']
  s.homepage    = 'http://medical-tribune.pl'
  s.summary     = 'CommonTags'
  s.description = 'Description of CommonTags.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 4.2.0'
  s.add_dependency 'hutch', '< 1.0.0'
  s.add_dependency 'select2-rails', '>= 4.0.0'
end
