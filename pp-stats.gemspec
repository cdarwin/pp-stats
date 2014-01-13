# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name          = 'pp-stats'
  s.version       = '0.0.2'
  s.date          = '2013-01-13'
  s.summary       = "Puppet Stats"
  s.description   = "Command line ruby program that generates stats for Puppet module(s)"
  s.authors       = ["Jason Thigpen"]
  s.email         = "darwin@sent.us"
  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.homepage      = 'http://rubygems.org/gems/pp-stats'
  s.license       = 'MIT'
end
