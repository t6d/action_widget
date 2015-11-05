module ActionWidget
  module ViewHelper
    def method_missing(name, *args, &block)
      widget = ActionWidget[name]
      return super if widget.nil?

      ActionWidget::ViewHelper.module_eval <<-RUBY
        def #{name}(*args, &block)               # def example_widget(*args, &block)
          #{widget}.render(self, *args, &block)  #   ExampleWidget.render(self, *args, &block)
        end                                      # end
      RUBY

      send(name, *args, &block)
    end

    def respond_to_missing?(name, include_private = false)
      !!ActionWidget[name] || super
    end
  end
end
