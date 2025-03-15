require 'rails/railtie'

module ActionWidget
  module Extensions
    module Rails
      class Railtie < ::Rails::Railtie
        rake_tasks do
          load File.expand_path("../action_widget_tasks.rake", __FILE__)
        end

        initializer "action_widget.helper" do
          ActiveSupport.on_load(:action_view) do
            include  ActionWidget::ViewHelper
          end
        end
      end
    end
  end
end
