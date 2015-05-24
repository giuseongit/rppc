require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc 'Run all specs'
RSpec::Core::RakeTask.new(:test) do |t|
    t.pattern = './spec/**/*_spec.rb'
    t.rspec_opts = ['--profile', '--color']
end

task :build do
    sh 'gem build rppc.gemspec'
end

task :default => :build
