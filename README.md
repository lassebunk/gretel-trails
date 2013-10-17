[![Build Status](https://secure.travis-ci.org/lassebunk/gretel-trails.png)](http://travis-ci.org/lassebunk/gretel-trails)

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

Breadcrumb trails are now hidden from the user so they don't see them in URLs. It uses data attributes and `history.replaceState` to hide the trails from the URL.
For older browsers it falls back gracefully to showing trails in the URL, as specified by `Gretel.trail_param`.

Note: If you use [Turbolinks](https://github.com/rails/turbolinks), it's important that you add the require *after* you require Turbolinks. Else it won't work.

## Usage

When you want to invisibly add the current trail when the user clicks a link, you add a special JS selector to the link where you want the trail added on click:

```erb
<% @products.each do |product| %>
  <%= link_to "My product", product, class: "js-append-trail" %>
<% end %>
```

Trails are now transferred invisibly to the next page when the user clicks a link.

See [Customization](#customization) below for info on changing the `.js-append-trail` selector.

If for some reason you want to add the trail directly on a link without the JS selector, you can do so:

```erb
<%= link_to "My Link", my_link_path, data: { trail: breadcrumb_trail } %>
```

See [Customization](#customization) below for info on changing the `data-trail` attribute to something else.

### Custom links

Inside breadcrumbs, the links are automatically transformed with trails removed from the URLs and applied as data attributes instead.
If you want to do custom breadcrumb links with these changes applied, you can use the `breadcrumb_link_to` helper:

```erb
<% parent_breadcrumb do |parent| %>
  <%= breadcrumb_link_to "Back to #{parent.text}", parent.url %>
<% end %>
```

The link will now have a URL without the trail param and `data-trail` containing the trail.

## Customization

### JS selector

If you want to customize the JS selector (the default is `.js-append-trail`), you can do so in an initializer:

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
Gretel.trail_param = :other_param
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
