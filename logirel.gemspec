# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "logirel/version"

Gem::Specification.new do |s|
  s.name        = "logirel"
  s.version     = Logirel::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Henrik Feldt"]
  s.email       = ["henrik@haf.se"]
  s.homepage    = "https://github.com/haf/logirel"
  s.summary     = %q{Logirel's a best-shot for scaffolding versioning for a .Net solution.}
  s.description = %q{The gem works by having as its dependencies 
  everything you need to get started with OSS and proprietary .Net coding.
  The aim of the gem is to allow developers to get up and running quickly
  and provide a nice way of converting a msbuild/VSS/svn project to github and rake.
  }

  s.rubyforge_project = "logirel"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency "rspec", "~> 2.6.0"  
  s.add_development_dependency "memoize"
  s.add_development_dependency "devver-construct"
  s.add_dependency "albacore", "~> 0.2.5"
  s.add_dependency "semver", "~> 1.0.1"
  s.add_dependency "bundler", "~> 1.0.14"
  s.add_dependency "thor"
  s.add_dependency "uuid"
  
  s.requirements << '.Net or Mono installation'
  s.requirements << 'xbuild (on linux) or msbuild (on windows) for csproj files'
  s.requirements << 'Access to the internet w/o a proxy! ;)'
  
end
