$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/pride'
require 'vcr'
require 'gyms-nearby'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end
