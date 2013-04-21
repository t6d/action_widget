# ActionWidget

ActionWidget is a light-weight widget system for Ruby on Rails and Middleman.
It is essentially a minimal tool set for building desktop-like UI components.
The main idea behind ActionWidget is the separation of the concept of an UI
component and its representation. While the representation of component might
easily change over time, the concept of a component is unlikely to change
significantly. Think of a button for instance: Most developers will agree that
a button is conceptually something that has a caption and when clicked triggers
an action.  When we think about the visual representation of a button, however,
things get more complicated. While most people will agree to a certain degree
on what can visually be considered a button and what is something else, people
tend to have different ideas of the exact representation of a button. There are
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

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
