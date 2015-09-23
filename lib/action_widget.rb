require 'smart_properties'

module ActionWidget
  class Configuration
    include SmartProperties
    property :prefix
    property :suffix

    attr_reader :pattern

    def initialize(*)
      super

      @pattern = Regexp.new([
        (prefix.underscore if prefix.presence),
        "(.*)",
        (suffix.underscore if suffix.presence)
      ].compact.join("_"))
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new(suffix: "Widget")
    end

    def configure(&block)
      @configuration = Configuration.new(&block)
    end

    def helper?(name)
      !!configuration.pattern.match(name)
    end

    def class_for(helper_name)
      basename = configuration.pattern.match(helper_name)[1]
      classname = [configuration.prefix, basename.camelcase, configuration.suffix].join("")
      classname.constantize
    end
  end
end

require 'action_widget/base'
require 'action_widget/view_helper'
require 'action_widget/extensions'
