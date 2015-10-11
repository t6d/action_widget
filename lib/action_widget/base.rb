module ActionWidget
  class Base < SimpleDelegator
    alias view __getobj__
    include SmartProperties

    attr_reader :options

    def initialize(view, attributes = {})
      properties = self.class.properties
      attributes, options = attributes.partition { |name, value| properties.key?(name) }

      @options = Hash[options]
      super(view, Hash[attributes])
    end

    def render
      raise NotImplementedError, "#{self.class} must implement #render"
    end
  end
end

