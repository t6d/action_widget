module ActionWidget
  module Extensions
    module Rails
      module Generators
        class Base < ::Rails::Generators::Base
          def self.namespace(name=nil)
            name || "action_widget"
          end
        end

        class ActionWidget < Base
          source_root File.expand_path('../../../../../support/templates', __FILE__)
          argument :name, :type => :string
          class_option :test, type: :boolean, default: true

          def generate_widget_implementation_file
            template('widget.rb.erb', implementation_path)
          end

          def generate_widget_test_file
            return unless options.test?

            if defined?(::RSpec)
              template('widget_spec.rb.erb', spec_path)
            else
              template('widget_test.rb.erb', test_path)
            end
          end

          private

          def configuration
            ::ActionWidget.configuration
          end

          def test_path
            File.join('test', configuration.directory, test_filename)
          end

          def test_filename
            "#{helper_name}_test.rb"
          end

          def spec_path
            File.join('spec', configuration.directory, spec_filename)
          end

          def spec_filename
            "#{helper_name}_spec.rb"
          end

          def implementation_path
            File.join('app', configuration.directory, implementation_filename)
          end

          def implementation_filename
            "#{helper_name}.rb"
          end

          def class_name
            [configuration.prefix, basename.classify, configuration.suffix].join('')
          end

          def superclass_name
            configuration.superclass.to_s
          end

          def minitest_superclass_name
            (configuration.minitest_superclass || "ActionView::TestCase").to_s
          end

          def helper_name
            class_name.underscore
          end

          def basename
            if match = name.underscore.match(configuration.pattern)
              match[1]
            else
              name
            end
          end
        end
      end
    end
  end
end
