
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gyms-nearby/version'

Gem::Specification.new do |spec|
  spec.name = "gyms-nearby"
  spec.version = GymsNearby::VERSION
  spec.authors       = ["Laura Unterguggenberger"]
  spec.email         = ["engine@jiff.com"]
  spec.description   = %q{The GymsNearby Gem to use Google nearbysearch to find nearby gyms.}
  spec.summary       = %q{This gem provides a ruby language library for working with lat long coordinates and give nearby gyms.}
  spec.platform    = Gem::Platform::RUBY
  spec.date        = '2017-02-24'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.10.1"
  spec.add_development_dependency "bundler", "~> 1.13.6"
  spec.add_runtime_dependency "faraday", "~> 0.11.0"
  spec.add_runtime_dependency "net-http-persistent", "~> 2.9.4"
end
