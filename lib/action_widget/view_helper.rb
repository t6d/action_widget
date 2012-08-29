module ActionWidget
  module ViewHelper
    
    def method_missing(name, *args, &block)
      super unless name =~ /_widget$/
    
      klass = begin
       @_action_widget_class_cache       = {}
       @_action_widget_class_cache[name] = "#{name.to_s.camelcase}".constantize
      rescue NameError => e
        super
      rescue LoadError => e
        super
      end
    
      klass.new(*args).render_in_context(self, &block)
    end

  end
end