# frozen_string_literal: true

require 'bundler/setup'
require 'pg_sql_caller'
require 'database_cleaner'

require_relative 'fixtures/active_record'

PgSqlCaller::Base.model_class 'ApplicationRecord'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
