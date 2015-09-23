module ActionWidget
  class Base < SimpleDelegator
    alias view __getobj__
    include SmartProperties

    def render
      raise NotImplementedError, "#{self.class} must implement #render"
    end
  end
end

