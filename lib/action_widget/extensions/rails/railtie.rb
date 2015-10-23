require 'rails/railtie'

module ActionWidget
  module Extensions
    module Rails
      class Railtie < ::Rails::Railtie
        initializer "action_widget.helper" do
          ActionView::Base.send(:include, ::ActionWidget::ViewHelper)
        end
      end
    end
  end
end
