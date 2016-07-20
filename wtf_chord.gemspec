# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'wtf_chord/version'

Gem::Specification.new do |spec|
  spec.name          = "wtf_chord"
  spec.version       = WTFChord::VERSION
  spec.authors       = ["Anton"]
  spec.email         = ["anton.estum@gmail.com"]

  spec.summary       = %q{‘WTF Chord?’ is the Ruby guitar chords generator library.}
  spec.description   = %q{‘WTF Chord?’ is the Ruby guitar chords generator library.}
  spec.homepage      = "https://github.com/estum/wtf_chord"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "methadone"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0", "< 4"
end
