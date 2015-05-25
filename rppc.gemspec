# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rppc/version'

Gem::Specification.new do |spec|
  spec.name          = "rppc"
  spec.version       = Rppc::VERSION
  spec.authors       = ["Giuseppe Pagano", "Tomasz Tadrzak"]
  spec.email         = ["giuseppe.pagano.p@gmail.com", "italiano.tt@libero.it"]
  spec.summary       = %q{RPPC - Ruby Peer-to-Peer chat}
  spec.description   = %q{rppc is a p2p chat written in ruby}
  spec.homepage      = "https://github.com/giuseongit/rppc"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
