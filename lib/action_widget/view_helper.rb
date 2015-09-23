module ActionWidget
  module ViewHelper

    def method_missing(name, *args, &block)
      return super unless ActionWidget.helper?(name)

      klass = begin
        ActionWidget.class_for(name)
      rescue NameError, LoadError
        return super
      end

      ActionWidget::ViewHelper.module_eval <<-RUBY
        def #{name}(*args, &block)                  # def example_widget(*args, &block)
          #{klass}.new(self, *args).render(&block)  #   ExampleWidget.new(self, *args).render(&block)
        end                                         # end
      RUBY

      send(name, *args, &block)
    end

  end
end
