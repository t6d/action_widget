module ActionWidget
  module Extensions
    module Rails
      module Generators
        
        class Base < ::Rails::Generators::Base
          
          def self.namespace(name=nil)
            super.sub(/extensions:rails:/, '')
          end
          
        end
        
        class Create < Base
          source_root File.expand_path('../../../../../support/templates', __FILE__)
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

        end
      
      end
    end
  end
end