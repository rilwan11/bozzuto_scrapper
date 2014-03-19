# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'allegro_scrapper'
require 'capybara'

Gem::Specification.new do |spec|
  spec.name          = "allegro_scrapper"
  spec.version       = "0.0.2"
  spec.authors       = ["Alex Bezobchuk", "Rilwan Alao"]
  spec.email         = ["Abezobchuk@gmail.com"]
  spec.description   = "Checks availability of available apartments in Allegro (possibly other places as well)"
  spec.summary       = "Checks availability of available apartments in Allegro (possibly other places as well)"

  spec.add_runtime_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'capistrano', '= 2.12.0'
  spec.add_development_dependency 'capistrano-multistage', '= 0.0.4'
  spec.add_runtime_dependency "rake"
  spec.add_dependency "whenever"
  spec.add_dependency "logbert"
  spec.add_dependency "mechanize"
  spec.add_dependency "mail"

end
