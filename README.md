# JsonApiReader

A simple json-api client.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json-api-reader'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json-api-reader

## Usage
Get all pages from a json-api endpoint. 
```ruby
JsonApiReader::Reader.all_pages(endpoint: 'https://my-endpoint.com/api/v1/foos', 
                                headers: {'Authorization' => 'Bearer mytoken'}) do |page_result|
  # page_result is instance of JsonApiReader::PageResult                                
  page_result.attributes.each do |attributes|
    MyModel.create(attributes)
  end
end
```

Or get just one page
```ruby
page_result = JsonApiReader::Reader.first_page(endpoint: 'https://my-endpoint.com/api/v1/foos')
```

Query parameters can be added with **query** parameter
```ruby
page_result = JsonApiReader::Reader.first_page(endpoint: 'https://my-endpoint.com/api/v1/foos', query: {page: 1, per_page: 100})
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/json-api-reader.

