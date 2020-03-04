# JekyllImageProcessing

Jekyll plugin for processing images using the [image_processing](https://github.com/janko/image_processing) and [libvips](http://libvips.github.io/libvips/).

## Installation

Add this line to your Jekyll site's Gemfile:

```ruby
gem 'jekyll_image_processing', git: 'https://github.com/benubois/jekyll_image_processing'
```

## Usage

Create a plugin in `_plugins/bundler.rb` with the contents:

```
require "rubygems"
require "bundler/setup"
Bundler.require(:default)
```

Define image presets in your _config.yml file, like this:

```yaml
image_processing:
  large:
    source: photos/original
    destination: photos/large
    resize_to_limit: [2048, 2048]
  thumbnail:
    source: photos/original
    destination: photos/thumbnail
    rotate: 90
    resize_to_limit: [2048, 2048]
    invert: null
    gaussblur: 20
    crop: [0, 0, 300, 300]
    gaussblur: 2
    rotate:
      args: 45
      background: [0, 0, 0]
    resize_to_fill:
      args: [640, 640]
      crop: attention
    saver:
      quality: 10
  tint:
    source: photos/original
    destination: photos/tint
    resize_to_limit: [1, 1]
```

See the [image_processing documentation](https://github.com/janko/image_processing/blob/master/doc/vips.md#readme) for all available commands.
