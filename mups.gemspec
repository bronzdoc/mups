# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mups/version'

Gem::Specification.new do |spec|
  spec.name          = "mups"
  spec.version       = Mups::VERSION
  spec.authors       = ["bronzdoc"]
  spec.email         = ["lsagastume1990@gmail.com"]

  spec.summary       = %q{Meetup streamming services}
  spec.description   = %q{Meetup streamming services}
  spec.homepage      = "https://github.com/bronzdoc/mups"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = "mups"
  spec.require_paths = ["lib"]

  spec.add_dependency "redis", "~> 3.3"
  spec.add_dependency "http", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "fakeredis", "~> 0.5"
end
