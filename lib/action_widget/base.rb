module ActionWidget
  class Base < SimpleDelegator
    alias view __getobj__
    include SmartProperties

    attr_reader :options

    def self.render(view, *args, &block)
      attrs = args.last.kind_of?(Hash) ? args.pop : {}
      self.new(view, **attrs).render(*args, &block)
    end

    def initialize(view, **kwargs)
      properties = self.class.properties
      attributes, options = kwargs.partition { |name, value| properties.key?(name) }

      @options = Hash[options]
      super(view, Hash[attributes])
    end

    def render
      raise NotImplementedError, "#{self.class} must implement #render"
    end
  end
end
