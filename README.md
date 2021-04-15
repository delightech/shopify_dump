# ShopifyDump

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/shopify_dump`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shopify_dump'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install shopify_dump

## Usage

1. Please make Rakefile and write below
```ruby
require 'shopify_api'
load 'shopify_api/graphql/task.rake'
```
2. Execute below rake task(require some environmet variables)
```sh
rake shopify_api:graphql:dump
```
3. Dump shopify data by GraphQL query
```ruby
require "shopify_dump"

query = <<~"QUERY"
{
  productVariants(query: "created_at:>=2021-01-01 AND created_at:<2021-04-01") {
    edges {
      node {
        id
        availableForSale
        barcode
        compareAtPrice
        createdAt
        displayName
        inventoryQuantity
        price
        sku
        taxable
        title
        updatedAt
        title
        product {
          id
          title
        }
      }
    }
  }
}
QUERY
dumper = ShopifyDump::Dumper.new
dumper.dump(query, 'product_variants')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shopify_dump. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/shopify_dump/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ShopifyDump project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/shopify_dump/blob/master/CODE_OF_CONDUCT.md).
