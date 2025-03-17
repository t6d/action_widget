# ActionWidget

`ActionWidget` is a light-weight widget system for [Ruby on
Rails](http://rubyonrails.com) and [Middleman](http://middlemanapp.com). It is
essentially a minimal tool set for building desktop-like UI components. The
main idea behind `ActionWidget` is the separation of the concept of an UI
component and its representation. While the representation of component might
easily change over time, the concept of a component is unlikely to change
significantly. Think of a button for instance: Most developers will agree that
a button is conceptually something that has a caption and when clicked triggers
an action.  When we think about the visual representation of a button, however,
things get more complicated. While most people will agree to a certain degree
on what can visually be considered a button and what is something else, people
tend to have different ideas about a button's exact representation. There are
buttons with icons, without icons, round ones, rectangular ones, and so on.
Despite their different appearances, the functionality and in this sense the
component's concept stays the same: when clicked an action is triggered.
ActionWidget provides developers with a tool set that helps them to strictly
decouple a component's concept from its representation to support future
change.

## Installation

Add `ActionWidget` to your application by running

    $ bundle add action_widget

or install it manually by running:

    $ gem install action_widget

### Ruby on Rails

If you're working with Ruby on Rails, please run

    $ bin/rails action_widget:install

in addition to one of the above commands to generate the initializer that allows 
you to configure `ActionWidget`. The resulting initializer will be located at 
`config/initializers/action_widget.rb` and should look as follows:

```ruby
ActionWidget.configure do |config|
  # config.class_prefix = ""
  config.class_suffix = "Widget"

  # config.helper_prefix = ""
  config.helper_suffix = "widget"

  config.directory = "widgets"
end
```

As shown in the example above, `ActionWidget` allows you to customize
prefixes and suffixes for class names and helper names, respectively, as well as
specify the directory name that will house your widgets within the `app/` directory.

## Usage

`ActionWidget` can be used to build arbitrarily complex view components. To
illustrate the basic usage of `ActionWidget`, however, we start with a simple
example, a widget for representing a button. We then continue with widgets that
except blocks. We will use a widget representing panels as an example. Finally,
we see discuss how to build widgets that utilize widgets themselves for
constructing navigation components.

### Simple Widgets

The goal of this section is to build a widget that represents a button. The
button we are designing must have a `caption` and a `type`. The type can either
be `regular`, `accept`, or `cancel`. The button further must have a specified
`size`, which can be `small`, `medium`, or `large`. Finally, the button
requires a `target` that defines the resource it links to.  `ActionWidget`
compentens utilize [SmartProperties](http://github.com/t6d/smart_properties) to
define attributes that can be configured to automatically enforce these
constraints and provide sensible defaults.

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

In both cases, the resulting HTML looks as follows:

```html
<a class="btn btn-small" href="/admin">Go to Admin Area</a>
```

### Widgets that Accept Blocks

The panel widget we are building requires a `title` and a block that defines the
widgets content.

```ruby
require 'action_widget'

class PanelWidget < ActionWidget::Base
  property :title, required: true, converts: :to_s

  def render(&block)
    content_tag(:div, class: 'panel') do
      content_tag(:h2, title, class: 'title') +
        content_tag(:div, class: 'content', &block)
    end
  end
end
```

Again, the automatically generated helper method, `#panel_widget` in this case,
can be used to instantiate and render the widget:

```erb
<%= panel_widget title: "Important Notice" do %>
  The system will be down for maintanence today.
<% end %>
```

Executing the code above results in the follwing HTML:

```html
<div class="panel">
  <h2 class="title">Important Notice</h2>
  <div class="content">
    The system will be down for maintanence today.
  </div>
</div>
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

### Option Capturing and Positional Argument Forwarding

`ActionWidget` instances capture all initializer keyword
arguments that do not correspond to a property in a general `options` hash.
All positional arguments supplied to an autogenerated helper are
forwarded to the `render` method.

```ruby
class ParagraphWidget < ActionWidget::Base
  def render(content, &block)
    content = capture(&block) if block
    content_tag(:p, content, class: options[:class])
  end
end
```

This widget can be used in the following two ways:

```erb
<%= paragraph_widget("Some content", class: 'important') %>

<%= paragraph_widget(class: 'important') do %>
  Some content
<% end %>
```

In both cases, the resulting HTML reads as follows:

```html
<p class="important">
  Some content
</p>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
