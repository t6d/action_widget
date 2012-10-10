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
      
      undef :capture if method_defined?(:capture)

      def method_missing(method, *args, &block)
        view.send(method, *args, &block)
      rescue NoMethodError
        # Double check - the NoMethodError might have occurred somewhere else.
        view.respond_to?(method) ? raise : super
      end
    
  end
end