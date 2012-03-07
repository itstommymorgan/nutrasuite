# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nutrasuite/version"

Gem::Specification.new do |s|
  s.name        = "nutrasuite"
  s.version     = Nutrasuite::VERSION
  s.authors     = ["Tommy Morgan","Alan Johnson"]
  s.email       = ["tommy.morgan@gmail.com","alan@commondream.net"]
  s.homepage    = "http://github.com/duwanis/nutrasuite"
  s.summary     = %q{Nutrasuite is a low-calorie syntax sweetener for minitest}
  s.description = %q{Nutrasuite is a low-calorie syntax sweetener for minitest}

  s.rubyforge_project = "nutrasuite"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "activesupport"
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
