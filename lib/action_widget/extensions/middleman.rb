require 'active_support/dependencies'

module ActionWidget
  module Extensions
    class Middleman < Middleman::Extension
      def self.register
        ::Middleman::Extensions.register(:action_widget, self)
      end

      option :path

      def initialize(app, *)
        super
        options.path ||= File.join(app.root, 'lib')
        raise ArgumentError, "Expected path to point to a directory" unless File.directory?(options.path)
      end

      def after_configuration
        ActiveSupport::Dependencies.autoload_paths |= [options.path]
        ActiveSupport::Dependencies.clear
        app.helpers(::ActionWidget::ViewHelper)
      end
    end
  end
end

ActionWidget::Extensions::Middleman.register
