require 'smart_properties'

module ActionWidget
  
  class Base
    
    include SmartProperties
    
    def render_in_context(view_context, &block)
      @view = view_context
      render(&block)
    end
    
    def render
      raise NotImplementedError, "#{self.class} must implement #render"
    end
    
    protected
    
      attr_reader :view
      
      undef :capture

      def method_missing(method, *args, &block)
        view.send(method, *args, &block)
      rescue NoMethodError
        super
      end
    
  end
  
  module Helper
    
    def method_missing(name, *args, &block)
      super unless name =~ /_widget$/
    
      klass = begin
        @_action_widget_class_cache ||= {}
        @_action_widget_class_cache[name] ||= "#{name.to_s.camelcase}".constantize
      rescue NameError => e
        super
      rescue LoadError => e
        super
      end
    
      klass.new(*args).render_in_context(self, &block)
    end

  end
  
  class Railtie < ::Rails::Railtie
  
    initializer "action_widget.helper" do
      ActionView::Base.send(:include, Helper)
    end
  
  end if defined?(Rails::Railtie)
  
end
