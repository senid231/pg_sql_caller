# frozen_string_literal: true

require_relative 'lib/pg_sql_caller/version'

Gem::Specification.new do |spec|
  spec.name          = 'pg_sql_caller'
  spec.version       = PgSqlCaller::VERSION
  spec.authors       = ['Denis Talakevich']
  spec.email         = ['senid231@gmail.com']

  spec.summary       = 'Postgresql Sql Caller for ActiveRecord'
  spec.description   = 'Postgresql Sql Caller for ActiveRecord.'
  spec.homepage      = 'https://github.com/didww/pg_sql_caller'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord'
  spec.add_dependency 'activesupport'
end
