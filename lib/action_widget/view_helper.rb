module ActionWidget
  module ViewHelper
    def method_missing(name, *args, &block)
      widget = ActionWidget[name]
      return super if widget.nil?

      ActionWidget::ViewHelper.module_eval <<-RUBY
        def #{name}(*args, &block)                          # def example_widget(*args, &block)
          attrs = args.last.kind_of?(Hash) ? args.pop : {}
          #{widget}.new(self, attrs).render(*args, &block)  #   ExampleWidget.new(self, attrs).render(*args, &block)
        end                                                 # end
      RUBY

      send(name, *args, &block)
    end

    def respond_to_missing?(name, include_private = false)
      !!ActionWidget[name] || super
    end
  end
end
