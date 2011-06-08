# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "logirel/version"

Gem::Specification.new do |s|
  s.name        = "logirel"
  s.version     = Logirel::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Henrik Feldt"]
  s.email       = ["henrik@haf.se"]
  s.homepage    = "https://github.com/haf/Logirel"
  s.summary     = %q{Logirel's a best-shot for scaffolding versioning for a .Net solution.}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "logirel"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency "rspec", "~> 2.6.0"
end
