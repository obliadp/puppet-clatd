require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppetlabs_spec_helper/rake_tasks'
require 'rspec-puppet-facts'
include RspecPuppetFacts

RSpec.configure do |c|
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
