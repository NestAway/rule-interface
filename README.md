# RuleInterface

A ruby interface communicate with Drools

[![Build Status](https://travis-ci.org/NestAway/rule-interface.svg?branch=master)](https://travis-ci.org/NestAway/rule-interface)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rule-interface'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rule-interface

## Usage

```
RuleExecutor.execute!(
  data_hash: {
    product: [
      {
        id: 12,
        name: 'Blah'
      },
      {
        id: 13,
        name: 'Bla2'
      }
    ],
    user: [
      {
        id: 123,
        email: 'yoman@manyo.com'
      }
    ]
  },
  namespace: :invensense,
  container: 'team_magic_v1.2.3',
  package: 'com.myteam.team_magic'
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rule-interface. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

