source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_GEM_VERSION') ? (ENV['PUPPET_GEM_VERSION']).to_s : ['>= 3.3']
gem 'facter', '>= 1.7.0'
if RUBY_VERSION < '2.0'
  # json 2.x requires ruby 2.0. Lock to 1.8
  gem 'json', '= 1.8'
  # json_pure 2.0.2 requires ruby 2.0, and 2.0.1 requires ruby 1.9. Lock to 1.8.3.
  gem 'json_pure', '= 1.8.3'
end
gem 'metadata-json-lint', '= 1.0.0'
gem 'puppet', puppetversion
gem 'puppet-lint', '= 2.1.0'
gem 'puppetlabs_spec_helper', '>= 0.8.2'
gem 'rspec-puppet'
# group :acceptance do
#   gem 'beaker-rspec'
# end
