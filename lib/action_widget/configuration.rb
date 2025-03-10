module ActionWidget
  class Configuration
    include SmartProperties
    property :prefix
    property :suffix
    property :superclass, required: true, default: -> { ActionWidget::Base }
    property :directory, required: true, converts: :to_s, accepts: ->(string) { !string.empty? }, default: -> { [underscored_prefix, underscored_suffix].compact.join("_").pluralize }
    property :minitest_superclass

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
