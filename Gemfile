# This file sets up tests
source 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'json', '~> 1.0' # json 2.0 and above require Ruby 2.0 or above
  gem 'json_pure', '= 2.0.1' # json_pure 2.0.2 and above require Ruby 2.0 or above
  gem 'puppet', ENV['PUPPET_VERSION'] || '~> 3.0'
  gem 'hiera-eyaml'
  gem 'rspec-puppet',
      git: 'https://github.com/rodjek/rspec-puppet.git'
  gem 'puppetlabs_spec_helper'
  gem 'rspec-puppet-facts',
      require: false
end
