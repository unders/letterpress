# -*- encoding: utf-8 -*-
require File.expand_path('../lib/letterpress/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Anders Törnqvist"]
  gem.email         = ["anders.tornqvist@gmail.com"]
  gem.description   = %q{A model factory}
  gem.summary       = %q{A model factory. Say no to fixtures.}
  gem.homepage      = "https://github.com/unders/letterpress"

  gem.files         = Dir.glob("{bin,lib,spec}/**/*") + %w[.gemtest
                                                           Gemfile
                                                           LICENSE
                                                           README.md
                                                           Rakefile
                                                           letterpress.gemspec]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "letterpress"
  gem.require_paths = ["lib"]
  gem.version       = Letterpress::VERSION

  gem.add_development_dependency "activerecord", "~> 3.1"
  gem.add_development_dependency "railties", "~> 3.1"
  gem.add_development_dependency "sqlite3", "~> 1.3.4"

  gem.add_development_dependency "minitest", ["~> 2.12"]
  gem.add_development_dependency "minitest-colorize", ["~> 0.0.4"]
end
