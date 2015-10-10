module ActionWidget
  class Base < SimpleDelegator
    alias view __getobj__
    include SmartProperties

    attr_reader :options

    def initialize(view, attributes = {})
      attributes = attributes.dup
      properties = self.class.properties

      @options = attributes.delete_if { |name, value| properties.key?(name) }

      super(view, attributes)
    end

    def render
      raise NotImplementedError, "#{self.class} must implement #render"
    end
  end
end

