require "rails/generators"

module ActionWidget
  class InitializerGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../../support/templates', __FILE__)

    def create_initializer_file
      template "initializer.rb.erb", Rails.root.join("config", "initializers", "action_widget.rb")
    end
  end
end

namespace :action_widget do
  desc "Install"
  task :install do
    require_relative './generators'
    ActionWidget::InitializerGenerator.start
  end
end