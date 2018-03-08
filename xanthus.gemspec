# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xanthus/version'

Gem::Specification.new do |spec|
  spec.name          = "xanthus"
  spec.version       = Xanthus::VERSION
  spec.authors       = ["Matt Haws"]
  spec.email         = ["matthaws@gmail.com"]

  spec.summary       = %q{Lightweight, simple backend Ruby MVC framework}
  spec.description   = %q{What started as a deep-dive into Rails functionality by simulating some of its core features grew into a stand-alone simple backend framework that can stand on its own.}
  spec.homepage      = "https://github.com/matthaws/xanthus"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "cucumber", "~> 1.3.20"
  spec.add_development_dependency "aruba"
  spec.add_dependency "rack", "~> 2.0.3"
  spec.add_dependency "sqlite3", "~> 1.3.13"
  spec.add_dependency "activesupport", "~> 5.1.4"
  spec.add_dependency "puma", "~> 3.11.0"
  spec.add_dependency "thor"
end
