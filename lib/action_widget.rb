require 'smart_properties'
require 'active_support/core_ext/string'

module ActionWidget
  class << self
    def [](helper_name)
      registry[helper_name]
    end

    def []=(helper_name, klass)
      registry[helper_name] = klass
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure(&block)
      @configuration = Configuration.new.tap(&block)
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
      match = configuration.helper_pattern.match(helper_name)
      return nil if match.nil?
      basename = match[1]
      classname = [configuration.class_prefix, basename.classify, configuration.class_suffix].join("")
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
