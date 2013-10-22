[![Build Status](https://secure.travis-ci.org/lassebunk/gretel-trails.png)](http://travis-ci.org/lassebunk/gretel-trails)

# Gretel::Trails

Gretel::Trails makes it possible to set [Gretel](https://github.com/lassebunk/gretel) breadcrumb trails via the URL – `params[:trail]`.
This makes it possible to link back to a different breadcrumb trail than the one specified in your breadcrumb, for example if you have a
store with products that have a default parent to their category, but when visiting from the reviews section, you want to link back to the reviews instead.

You can also hide trails from the user using the `:hidden` strategy, so they don't see them in URLs when navigating your site. See below for more info.

## Installation

Add this line to your Gemfile:

```bash
gem 'gretel-trails'
```

And run:

```bash
$ bundle
```

Gretel::Trails has different stores that are used to serialize and deserialize the trails for use in URLs.

The default store is the URL store that encodes trails directly in the URL. Note that a trail stored in the URL can get very long, so the recommended way is to use the database or Redis store. See [Stores](#stores) below for more info.

In order to use the URL store, you must set a secret that's used to prevent cross-site scripting attacks. In an initializer, e.g. *config/initializers/gretel.rb*:

```
Gretel::Trails.configure do |config|
  config.store.secret = 'your_key_here' # Must be changed to something else to be secure
end
```

You can generate a secret using `SecureRandom.hex(64)` or `rake secret`.

Then you can set the breadcrumb trail:

```erb
<% breadcrumb :reviews %>
...
<% @products.each do |product| %>
  <%= link_to @product.name, product_path(product, trail: breadcrumb_trail) %>
<% end %>
```

The product view will now have the breadcrumb trail from the first page (reviews) instead of its default parent.

## Custom trail param

The default trail param is `params[:trail]`. You can change it in an initializer:

```ruby
Gretel::Trails.configure do |config|
  config.trail_param = :other_param
end
```

## Hiding trails in URLs

Gretel::Trails has a `:hidden` strategy that can be used to hide trails in URLs from the user while the server sees them. This is done via data attributes and `history.replaceState` in browsers that support it.

To hide trails, you set the strategy in an initializer, e.g. *config/initializers/gretel.rb*:

```ruby
Gretel::Trails.configure do |config|
  config.strategy = :hidden
end
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
For older browsers it falls back gracefully to showing trails in the URL, as specified by `Gretel::Trails.trail_param`.

Note: If you use [Turbolinks](https://github.com/rails/turbolinks), it's important that you add the require *after* you require Turbolinks. Else it won't work.

### Usage

When you want to invisibly add the current trail when the user clicks a link, you add a special JS selector to the link where you want the trail added on click:

```erb
<% @products.each do |product| %>
  <%= link_to "My product", product, class: "js-append-trail" %>
<% end %>
```

Trails are now transferred invisibly to the next page when the user clicks a link.

See [Customization](#customization) below for info on changing the `.js-append-trail` selector.

If you need to set the trail directly on a link without the JS selector, you can do so:

```erb
<%= link_to "My Link", my_link_path, data: { trail: breadcrumb_trail } %>
```

See [Customization](#customization) below for info on changing the `data-trail` attribute to something else.

### Breadcrumb links

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

`data-` is added automatically, so if for example you want the attribute to be `data-my-attr`, you just set it to `my-attr`.

## Stores

Gretel::Trails comes with different stores for encoding and decoding trails for use in the URL.

### URL store

The default store is the URL store which is great for simple use, but if you have longer trails, it can get very long.

To use the URL store, set it in an initializer, e.g. *config/initializers/gretel.rb*:

```ruby
Gretel::Trails.configure do |config|
  config.store = :url # Not really needed as this is the default
  config.store.secret = 'your_key_here' # Must be changed to something else to be secure
end
```

The secret is used to prevent cross-site scripting attacks. You can generate a secure one using `SecureRandom.hex(64)` or `rake secret`.

### Database store

The database store stores trails in the database so the trail keys have a maximum length of 40 characters (a SHA1 of the trail).

To use the database store, set it an initializer, e.g. *config/initializers/gretel.rb*:

```ruby
Gretel::Trails.configure do |config|
  config.store = :db
end
```

You also need to create a migration for the database table that holds the trails:

```bash
$ rails generate gretel:trails:migration
```

This creates a table named `gretel_trails` that hold the trails.

ActiveRecord doesn't delete expired records automatically, so to delete expired trails you need to run the following rake task, for example once daily:

```bash
$ rake gretel:trails:delete_expired
```

You can also run `Gretel::Trails.delete_expired` directly.

If you need a gem for managing recurring tasks, [Whenever](https://github.com/javan/whenever) is a solution that handles cron jobs via Ruby code.

The default expiration period is 1 day. To set a custom expiration period, in an initializer:

```ruby
Gretel::Trails.configure do |config|
  config.store = :db
  config.store.expires_in = 2.days
end
```

### Redis store

If you want to store trails in [Redis](https://github.com/redis/redis), you can use the Redis store.

To use the Redis store, set it in an initializer, e.g. *config/initializers/gretel.rb*:

```ruby
Gretel::Trails.configure do |config|
  config.store = :redis
  config.store.connect_options = { host: "10.0.1.1", port: 6380 }
end
```

Trails are now stored in Redis and expired automatically after 1 day (by default).

To set a custom expiration period, in an initializer:

```ruby
Gretel::Trails.configure do |config|
  config.store = :redis
  config.store.expires_in = 2.days
end
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
