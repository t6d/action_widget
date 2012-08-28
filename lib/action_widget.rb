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
  
  end if defined?(::Rails::Railtie)
  
  class CreateWidget < ::Rails::Generators::Base
    source_root File.expand_path('../../support/templates', __FILE__)
    argument :widget_name, :type => :string
    class_option :rspec, :type => :boolean, :default => true, :description => "Generates rspec file"
    
    def generate_widget_implementation_file
      empty_directory 'app/widgets'
      template('widget.rb.erb', "app/widgets/#{widget_implementation_filename}")
    end
    
    def generate_widget_spec_file
      if defined?(::RSpec) && options.rspec?
        empty_directory 'spec/widgets'
        template('widget_spec.rb.erb', "spec/widgets/#{widget_spec_filename}")
      end
    end
    
    private
    
      def widget_spec_filename
        "#{widget_helper_name}_spec.rb"
      end
      
      def widget_implementation_filename
        "#{widget_helper_name}.rb"
      end
      
      def widget_class_name
        /[Ww]idget$/.match(widget_name) ? widget_name.classify : "#{widget_name.classify}Widget"
      end
      
      def widget_helper_name
        widget_class_name.underscore
      end
      
  end if defined?(::Rails::Generators::Base)
  
end
