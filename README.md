# PgSqlCaller

Postgresql Sql Caller for ActiveRecord.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pg_sql_caller'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pg_sql_caller

## Usage

create subclass from `PgSqlCaller::Base` and define `model_class` for it

```ruby
require 'pg_sql_caller'

class MySqlCaller < PgSqlCaller::Base
  model_class 'ApplicationRecord'
end

MySqlCaller.select_values 'SELECT id from users WHERE parent_name = ?', 'John Doe' # => [1, 2, 3]
```

or just define `model_class` for `PgSqlCaller::Base` itself

```ruby
PgSqlCaller::Base.model_class 'ApplicationRecord'

PgSqlCaller::Base.select_values 'SELECT id from users WHERE parent_name = ?', 'John Doe' # => [1, 2, 3]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Create `spec/config/database.yml` (look at `spec/config/database.travis.yml` for example).
You need to create test database, so run `psql -c 'CREATE DATABASE pg_sql_caller_test;'`.
Then, run `rake spec` to run the tests. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## TODO

* add more tests
* add more usage examples
* add documentation
* release 1.0 after all above

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/didww/pg_sql_caller. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/didww/sql_caller/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PGSqlCaller project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/didww/pg_sql_caller/blob/master/CODE_OF_CONDUCT.md).
