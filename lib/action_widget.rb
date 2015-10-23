require 'smart_properties'

module ActionWidget
  class << self
    def [](helper_name)
      registry[helper_name]
    end

    def []=(helper_name, klass)
      registry[helper_name] = klass
    end

    def configuration
      @configuration ||= Configuration.new(suffix: "Widget")
    end

    def configure(&block)
      @configuration = Configuration.new(&block)
    end

    def helper?(name)
      !!configuration.pattern.match(name)
    end

    protected

    def registry
      @registry ||= Hash.new do |registry, helper_name|
        if klass = find_action_widget(helper_name)
          registry[helper_name] = klass
        else
          nil
        end
      end
    end

    private

    def find_action_widget(helper_name)
      return nil unless helper?(helper_name)
      basename = configuration.pattern.match(helper_name)[1]
      classname = [configuration.prefix, basename.camelcase, configuration.suffix].join("")
      classname.constantize
    rescue NameError, LoadError
      nil
    end
  end
end

require 'action_widget/base'
require 'action_widget/configuration'
require 'action_widget/view_helper'
require 'action_widget/extensions'
require 'action_widget/version'
