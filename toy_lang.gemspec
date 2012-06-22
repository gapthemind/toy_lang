# -*- encoding: utf-8 -*-
require File.expand_path('../lib/toy_lang/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Diego Alonso"]
  gem.email         = ["diego@gapthemind.net"]
  gem.description   = %q{tay language parser}
  gem.summary       = %q{Toy Language parser and scanner to play with language compilation}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "toy_lang"
  gem.require_paths = ["lib"]
  gem.version       = ToyLang::VERSION
end
