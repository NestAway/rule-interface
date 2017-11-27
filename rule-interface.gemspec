# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rule-interface/version'

Gem::Specification.new do |s|
  s.name          = "rule-interface"
  s.version       = RuleInterface::VERSION
  s.date          = '2017-11-27'
  s.authors       = ["Ranveer"]
  s.email         = ["ranveernitk@gmail.com"]

  s.summary       = 'ruby interface for drool rule engine'
  s.description   = 'API integration for Drool BRMS'
  s.homepage      = 'https://github.com/NestAway/rule-interface'
  s.license       = 'Apache License 2.0'

  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  s.required_ruby_version = '>= 1.9.8'
  s.require_paths = ['lib']

  s.add_dependency 'activerecord', '~> 3'
  s.add_dependency 'activerecord-nulldb-adapter', '~> 0'
  s.add_dependency 'restforce', '~> 2.5'

  s.add_development_dependency 'byebug', '~> 9'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'bundler', '~> 1.15'
  s.add_development_dependency 'rake', '~> 10.0'
end
