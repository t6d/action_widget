# ActionWidget

ActionWidget is a light-weight widget system for [Ruby on
Rails](http://rubyonrails.com) and [Middleman](http://middlemanapp.com).  It is
essentially a minimal tool set for building desktop-like UI components.  The
main idea behind ActionWidget is the separation of the concept of an UI
component and its representation. While the representation of component might
easily change over time, the concept of a component is unlikely to change
significantly. Think of a button for instance: Most developers will agree that
a button is conceptually something that has a caption and when clicked triggers
an action.  When we think about the visual representation of a button, however,
things get more complicated. While most people will agree to a certain degree
on what can visually be considered a button and what is something else, people
tend to have different ideas about a buttons's exact representation. There are
buttons with icons, without icons, round ones, rectangular ones, and so on.
Despite their different appearances, the functionality and in this sense the
component's concept stays the same: when clicked an action is triggered.
ActionWidget provides developers with a tool set that helps them to strictly
decouple a component's concept from its representation to support future
change.

## Installation

Add this line to your application's Gemfile:

    gem 'action_widget'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action_widget

## Usage

`ActionWidget` can be used to build arbitrarily complex view components. To
illustrate the basic usage of `ActionWidget`, however, we start with a simple
example, a widget for representing a button, and then continue with widgets
that except blocks. We will use a panel widget as an example. Finally, we see
discuss how to build widgets that utilize wigets themselves for constructing
navigation components.

### Simple Widgets

The button we are designing must have a `caption` and a `type`. The type can
either be `regular`, `accept`, or `cancel`. The button further must have a
specified `size`, which can be `small`, `medium`, or `large`. Finally, the
button requires a `target` that defines the resource it links to.
`ActionWidget` compentens utilize
[SmartProperties](http://github.com/t6d/smart_properties) to define attributes
that can be configured to automatically enforce these constraints and provide
sensible defaults.

In the example below, we simple use an `<a>` tag to represent a button. The
attributes `size` and `type` are simply translated into CSS classes. The
`caption` will be used as the text encolsed by the `<a>` tag and the `target`
will be used as the value the the `<a>` tag's `href` attribute.

```ruby
class ButtonWidget < ActionWidget::Base
  property :caption,
    converts: :to_s,
    required: true

  property :target,
    converts: :to_s,
    accepts: lambda { |uri| URI.parse(uri) rescue false },
    required: true

  property :type,
    converts: :to_sym,
    accepts: [:regular, :accept, :cancel],
    default: :regular

  property :size,
    converts: :to_sym,
    accepts: [:small, :medium, :large],
    default: :medium

  def render
    content_tag(:a, caption, href: target, class: css_classes)
  end

protected

  def css_classes
    css_classes = ['btn']
    css_classes << "btn-#{size}" unless size == :regular
    css_classes << "btn-#{type}" unless type == :medium
    css_classes
  end
end
```

By convention, a widget's class name should end in "Widget". This way,
`ActionWidget` automatically generates `ActionView` helper methods for more
convenient instantiation and rendering of a widget.

In our example, the widget can be instantiated by simply calling the helper
method `button_widget` and providing it with all necessary attributes:

```erb
<%= button_widget caption: 'Go to Admin Area', size: :small, target: '/admin' %>
```

Instead of using the provided helper method, a widget can always be instantiated
manually:

```erb
<%= ButtonWidget.new(self, caption: 'Go to Admin Area', size: :small, target: '/admin').render %>
```

### Widgets that Accept Blocks

The panel widget we are building requires a `title` and a block that defines the
widgets content.

```ruby
require 'action_widget'

class PanelWidget < ActionWidget::Base
  property :title, required: true, converts: :to_s

  def render(&block)
    content_tag(:h2, title) +
      content_tag(:div, &block)
  end
end
```

Since widgets are simple Ruby classes, they naturally support inheritance.
Let's assume we require a special panel widget for sidebars that renders a
different header. There are two options:

1. we can provide the tag that is chosen for the header as a property, or
2. we restructure the `PanelWidget` class and then subclass it.

Let's take the second approach and extract the header rendering and the content
rendering into their own methods so we can overwrite either one of them in a
potential subclass.

```ruby
class PanelWidget < ActionWidget::Base
  property :title, required: true, converts: :to_s

  def render(&block)
    header + content(&block)
  end

  protected

  def header
    content_tag(:h2, title)
  end

  def content(&block)
    content_tag(:div, &block)
  end
end
```

After this refactoring, we are able to subclass `PanelWidget` and customize the
`header` method:

```ruby
class SidebarPanelWidget < PanelWidget
  protected

  def header
    content_tag(:h3, title)
  end
end
```

### Nested Widgets

Let's assume we want to implement a widget that simplifies the rendering of
navigational menus. The widget only exposes one property, `orientation`, which
can either be `horizontal` or `vertical`.

```ruby
class MenuWidget < ActionWidget::Base
  property :orientation,
    accepts: [:horizontal, :vertical],
    converts: :to_sym,
    default: :horizontal,
    required: true

  def render(&block)
    content_tag(:nav, class: orientation) do
      content_tag(:ul) do
        capture(self, &block)
      end
    end
  end

  def item(caption, target)
    content_tag(:li) do
      content_tag(:a, caption, href: target)
    end
  end

  def submenu(caption, &block)
    content_tag(:li) do
      content_tag(:span, caption) +
        self.class.new(view, orientation: orientation).render(&block)
    end
  end
end
```

The following example demonstrates how to use this widget:

```erb
<%= menu_widget do |m| %>
  <%= m.item "Dashboard", "/" %>
  <%= m.submenu "Admin" do |m| %>
    <%= m.item "Manage Users", "/admin/users" %>
    <%= m.item "Manage Groups", "/admin/groups" %>
  <% end %>
<% end %>
```

Executing the code above, will result in the following HTML being generated:

```html
<nav class="horizontal">
  <ul>
    <li> <a href="/">Dashboard</a> </li>
    <li>
      <span>Admin</span>
      <nav class="horizontal">
        <ul>
          <li><a href="/admin/users">Manage Users</a></li>
          <li><a href="/admin/groups">Manage Groups</a></li>
        </ul>
      </nav>
    </li>
  </ul>
</nav>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
