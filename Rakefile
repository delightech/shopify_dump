# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

load 'shopify_api/graphql/task.rake'

task default: %i[spec]

