# RailsWholeValues

Make it easier to wrap rich types in your rails models

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_values'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rails_values

## Usage

### EmailAddress

```ruby
class Person < ApplicationRecord
  attribute :email, :rv_email_address

  validates :email, value: true
end

p = Person.new(email: "person@email.com")
puts p.email.subdomain # "email.com"
puts p.email.another_with_same_domain("other") # "other@email.com"
puts p.email.free_email? # true
puts p.email.free_email? # true
```

### PublicDomainSuffix

uses https://github.com/weppos/publicsuffix-ruby under the hood

```ruby
class Company < ApplicationRecord
  attribute :domain_suffix, :rv_public_domain_suffix

  validates :domain_suffix, value: true
end

c = Company.new(domain: "www.example.com")
puts c.domain_suffix.local_email("test") # RailsValues::EmailAddress(test@example.com)
puts c.domain_suffix.tld # "com"
puts c.domain_suffix.sld # "example"
puts c.domain_suffix.trd # "www"
puts c.domain_suffix.free_email? # false
puts c.domain_suffix.domain # RailsValues::PublicDomainSuffix(example.com)
puts c.domain_suffix.subdomain # RailsValues::PublicDomainSuffix(www.example.com)
```

### Subdomain

```ruby
class Company < ApplicationRecord
  attribute :subdomain, :rv_subdomain

  validates :subdomain, value: true
end

c = Company.new(subdomain: "example.com")
puts c.subdomain.local_email("test") # "test@example.com"
puts c.subdomain.parts # ["example", "com"]
puts c.subdomain.free_email? # false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rails_whole_values.

