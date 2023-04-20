require 'spec_helper'

class DummyWidget < ActionWidget::Base
  property :type

  def render(content = nil)
    classes = [options[:class], type].compact
    if classes.empty?
      content_tag(:p, content)
    else
      content_tag(:p, content, class: classes)
    end
  end
end

class ViewContext < ActionView::Base
  include ActionWidget::ViewHelper
end

RSpec.describe ViewContext do
  subject(:view_context) { described_class.empty }
  it 'should implement #respond_to_missing?' do
    expect(view_context.send(:respond_to_missing?, :dummy_widget)).to eq(true)
  end
end

RSpec.describe DummyWidget do
  let(:view) { ViewContext.empty }

  it "should delegate unknown method calls to the view context" do
    expect(described_class.new(view).render).to eq("<p></p>")
  end

  context "option capturing and positional argument forwarding" do
    let(:expected_html) { '<p class="wide teaser">Hello World</p>' }

    it "should be possible to reference a property using a symbol" do
      attributes = {type: 'teaser', class: 'wide'}
      expect(view.dummy_widget("Hello World", attributes)).to eq(expected_html)
    end

    it "should be possible to reference a property using a string" do
      attributes = {"type" => 'teaser', class: 'wide'}
      expect(view.dummy_widget("Hello World", attributes)).to eq(expected_html)
    end

    specify "keyword arguments that do not correspond to a property should be captured as options" do
      instance = described_class.new(view, class: 'wide')
      expect(instance.options).to eq({class: 'wide'})
    end
  end
end
