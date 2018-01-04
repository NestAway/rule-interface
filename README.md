# RuleInterface

A ruby interface to convert and communicate with Drools

[![Build Status](https://travis-ci.org/NestAway/rule-interface.svg?branch=master)](https://travis-ci.org/NestAway/rule-interface)

## Use case

- Using [Drools](https://www.drools.org/)
- Want a easy way to convert the data to Drools format and send
- Stateless session
- Agenda group implementation for stateless session (We call it namespace)

## Expectation

Currently this Gem is designed for stateless session.

Using this you can pass a set of data (facts in Drools) and get the same data back with the modification happended (based on your rule) in Drools

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rule-interface'
```

And then execute:

```shell
bundle
```

Or install it yourself as:

```shell
gem install rule-interface
```

## Configuration

ENV variable can be used to configure KIE server details

`KIE_SERVER_USERNAME`, `KIE_SERVER_PASSWORD`, `KIE_SERVER_HOSTNAME`

You can also configure the KIE server details programmatically

```ruby
RuleInterface::Configuration.setup do |config|
  config.kiesever_config = {
    username: 'blah',
    password: 'blah',
    hostname: 'http://url',
  }
end
```

All the attribute specified in the above configuration is optional. If specified, it will overwrite ENV configuration for that attribute

## Usage

```ruby
RuleInterface.execute!(
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
    user: { # Array only if multiple objects, we handle it
      id: 123,
      email: 'yoman@manyo.com'
    }
  },
  container: 'team_magic_v1.2.3',
  package: 'com.myteam.test',
  namespace: :test,
  session: 'blah'
)
```

### Arguments explaind

#### data_hash
Used to send data to Drools.

**Syntax**:
Inside root hash, define the data class name in ruby style as the key and put the value as an array of objects or a signle object

Let's say the data class name (ruby style) you put as `line_item`, this will get converted to `{package}.LineItem`

Object is a key value pair (Nested objects are not supported right now). And `id` should be an uniq identifire for the class and `id` is optional, if passed we'll return the object back

#### container
Container name of the KIE server

#### package
The package name of your JAVA models (fact class) created. And this package name will get automatically added to your data_hash models

#### namespace
> Optional argument

As stateless session doesn't support agenda group feature in Drools, we build namespace as a hack for it

Create a fact class in your Drools project as shown below

```
Namespace {
  :name
}
```

**Example rule**:
```
rule "rule 1"
when
  Namespace(name == "campine_1")
  Product(amount > 200)
then
  // Do something here
end
```

And you pass `campine_1` as your namesapce

#### session
> Optional argument

Default session name in the Gem is `session`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rule-interface. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [Apache-2.0](https://opensource.org/licenses/Apache-2.0).

