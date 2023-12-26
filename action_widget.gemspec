# frozen_string_literal: true

require File.expand_path('lib/action_widget/version.rb', __dir__)

Gem::Specification.new do |gem|
  gem.authors               = ['Konstantin Tennhard']
  gem.email                 = ['me@t6d.de']
  gem.summary               = 'Reusable view components for your Ruby web application'
  gem.homepage              = 'http://github.com/t6d/action_widget'

  gem.files                 = `git ls-files`.split($\)
  gem.executables           = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files            = gem.files.grep(%r{^(test|spec|features)/})
  gem.name                  = 'action_widget'
  gem.require_paths         = ['lib']
  gem.version               = ActionWidget::VERSION
  gem.required_ruby_version = '>= 2.7.0'

  gem.add_dependency 'activesupport', '> 2.2'
  gem.add_dependency 'smart_properties', '~> 1.10'

  gem.add_development_dependency 'actionview', '>= 6.0'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.3'
  gem.add_development_dependency 'ruby-lsp'
end
