# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skink/version'

Gem::Specification.new do |gem|
  gem.name          = "skink"
  gem.version       = Skink::VERSION
  gem.authors       = ["Todd Thomas"]
  gem.email         = ["todd.thomas@openlogic.com"]
  gem.description   = %q{A Ruby DSL for testing REST APIs.}
  gem.summary       = %q{Skink is Capybara's smaller, more primitive companion.}
  gem.homepage      = "https://github.com/toddthomas/skink.git"

  gem.add_dependency "rack-test"
  gem.add_dependency "openlogic-resourceful"
  gem.add_dependency "nokogiri"
  gem.add_dependency "jsonpath"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "sinatra"
  gem.add_development_dependency "rake"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
