require 'spec_helper'

RSpec.describe ActionWidget::Base do
  let(:view) { ActionView::Base.new }

  subject(:dummy_widget) do
    Class.new(described_class) do
      def render
        tag(:br, class: options[:class])
      end
    end
  end

  it "should delegate unknown method calls to the view context" do
    expect(dummy_widget.new(view).render).to eq("<br />")
  end

  it "should should capture all keyword arguments that do not belong to a property in an options hash" do
    instance = dummy_widget.new(view, class: 'wide')
    expect(instance.options).to eq({class: 'wide'})
    expect(instance.render).to eq('<br class="wide" />')
  end
end
