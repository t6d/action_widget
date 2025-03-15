module ActionWidget
  class Configuration
    include SmartProperties

    property :class_prefix
    property :class_suffix, default: "Widget"
    property :helper_prefix
    property :helper_suffix, default: "widget"
    property! :superclass, default: "ActionWidget::Base"
    property! :directory,
              converts: :to_s,
              accepts: ->(string) { !string.empty? },
              default: "widgets"
    property! :minitest_superclass,
              default: "ActionView::TestCase"

    def class_pattern
      Regexp.new("^%s$" % [class_prefix, "(.*?)", class_suffix].compact.join(""))
    end

    def helper_pattern
      Regexp.new("^%s$" % [helper_prefix, "(.*?)", helper_suffix].compact.join("_"))
    end
  end
end
