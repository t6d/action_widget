# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Konstantin Tennhard"]
  gem.email         = ["me@t6d.de"]
  gem.summary       = %q{Reusable view components for your Ruby web application}
  gem.homepage      = "http://github.com/t6d/action_widget"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "action_widget"
  gem.require_paths = ["lib"]
  gem.version       = "0.3.1"
  
  gem.add_dependency 'smart_properties', '~> 1.1'
end
