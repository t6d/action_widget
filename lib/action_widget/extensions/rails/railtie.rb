require 'rails/railtie'

module ActionWidget
  module Extensions
    module Rails
      class Railtie < ::Rails::Railtie
        initializer "action_widget.helper" do
          ActiveSupport.on_load(:action_view) do
            include  ActionWidget::ViewHelper
          end
        end
      end
    end
  end
end
