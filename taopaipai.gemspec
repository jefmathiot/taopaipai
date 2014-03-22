# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taopaipai/version'

Gem::Specification.new do |spec|
  spec.name          = "taopaipai"
  spec.version       = Taopaipai::VERSION
  spec.authors       = ["Jef Mathiot"]
  spec.email         = ["jeff.mathiot@gmail.com"]
  spec.summary       = %q{Access Raspberry Pi GPIO from Linux User Space.}
  spec.description   = %q{Access Raspberry Pi PGIO from Linux User Space.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "minitest", "~> 5.0.7"
  spec.add_development_dependency "minitest-implicit-subject", "~> 1.4.0"
  spec.add_development_dependency "rb-readline", "~> 0.5.0"
  spec.add_development_dependency "guard-minitest", "~> 2.1.3"

end
