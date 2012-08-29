module ActionWidget
  module Extensions  
    module Middleman
  
      class << self
        
        def register!
          ::Middleman::Extensions.register(:action_widget, self)
        end
        
        def registered(app)
          app.send(:include, ::ActionWidget::ViewHelper)
        end
        alias included registered
    
      end
  
    end
  end
end

ActionWidget::Extensions::Middleman.register!