# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gretel/trails/version'

Gem::Specification.new do |spec|
  spec.name          = "gretel-trails"
  spec.version       = Gretel::Trails::VERSION
  spec.authors       = ["Lasse Bunk"]
  spec.email         = ["lassebunk@gmail.com"]
  spec.description   = %q{Gretel::Trails is a collection of strategies for handling Gretel trails.}
  spec.summary       = %q{Collection of strategies for handling Gretel trails.}
  spec.homepage      = "https://github.com/lassebunk/gretel-trails"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_dependency "gretel", ">= 3.0.0.beta4"
  spec.add_dependency "rails", ">= 3.2.0"
  spec.add_development_dependency "rails", "~> 3.2.13"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "capybara", "~> 2.1.0"
  spec.add_development_dependency "capybara-webkit", "~> 1.0.0"
end
