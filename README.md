# Gretel::Trails

Gretel::Trails makes it easy to hide [Gretel](https://github.com/lassebunk/gretel) breadcrumb trails from the user, so they don't see them in URLs when navigating your site.

## Installation

Add this line to your Gemfile:

```bash
gem 'gretel-trails'
```

And run:

```bash
$ bundle
```

In an initializer, e.g. *config/initializers/gretel.rb*:

```ruby
Gretel::Trails.strategy = :hidden
```

Add a data attribute with the trail to your `<body>` tag, in *application.html.erb*:

```erb
<body data-trail="<%= breadcrumb_trail %>">
...
```

And finally, at the bottom of *app/assets/javascripts/application.js*:

```js
//= require gretel.trails.hidden
```

Note: If you use [Turbolinks](https://github.com/rails/turbolinks), it's important that you add the require *after* you require Turbolinks. Else it won't work.

Breadcrumb trails are now hidden from the user so they don't see them in URLs. It uses data attributes and `history.replaceState` to transfer the trails.
For older browsers it falls back gracefully to showing trails in the URL, as specified by `Gretel::Trail.trail_param`.

## Usage

When you want to invisibly add the current trail when the user clicks a link, you add a special JS selector to the link where you want the trail added on click:

```erb
<% @products.each do |product| %>
  <%= link_to "My product", product, class: "js-append-trail" %>
<% end %>
```

Trails are now transferred invisibly to the next page when the user clicks a link.

See Customization below for info on changing this selector.

## Customization

### JS selector

If you want to customize the JS selector, you can do so in an initializer:

```ruby
Gretel::Trails::HiddenStrategy.js_selector = ".my-other-selector"
```

It supports all [CSS selectors](http://api.jquery.com/category/selectors/) that you can use in jQuery.

### Data attribute

The default trail data attribute for `<body>` and links is `data-trail` but you can change this in an initializer:

```ruby
Gretel::Trails::HiddenStrategy.data_attribute = "other-data-attribute"
```

That's it. :)

### Trail param

The trail param that's hidden from the user is `params[:trail]` by default. You can change this in an initializer:

```ruby
Gretel::Trail.trail_param = :other_param
```

## Requirements

* Ruby >= 1.9.3 (1.9.2 may work)
* Rails >= 3.2.0
* Gretel >= 3.0.0
* jQuery

## Contributing

You are very welcome to contribute with bug fixes or new features. To contribute:

1. Fork the project
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new pull request

## Versioning

Follows [semantic versioning](http://semver.org/).

Copyright (c) 2013 [Lasse Bunk](http://lassebunk.dk), released under the MIT license
