module ActionWidget
  class Configuration
    include SmartProperties
    property :prefix
    property :suffix

    attr_reader :pattern

    def initialize(*)
      super

      @pattern = Regexp.new("^%s$" % [
        underscored_prefix,
        "(.*)",
        underscored_suffix
      ].compact.join("_"))
    end

    private

    def underscored_prefix
      return if prefix.nil?
      prefix.underscore
    end

    def underscored_suffix
      return if suffix.nil?
      suffix.underscore
    end
  end
end
