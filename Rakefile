require "bundler/gem_tasks"

require "bundler/gem_tasks"
require "bundler/setup"
require 'rake/testtask'

task :default => :test

desc "Run the Test Suite, toot suite"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/test_*.rb"
end

task :console do
  require 'irb'
  require 'irb/completion'
  lib = File.expand_path('../lib', __FILE__)
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
  require 'gyms-nearby'
  ARGV.clear
  IRB.start
end