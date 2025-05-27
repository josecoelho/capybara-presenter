# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

# Main gem tests
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

# Demo and example tasks
namespace :demo do
  desc "Run the sample app system tests in normal mode"
  task :test do
    Dir.chdir("examples/sample_app") do
      sh "ruby system_test.rb"
    end
  end

  desc "Run the sample app system tests in demo mode"
  task :run do
    Dir.chdir("examples/sample_app") do
      sh "DEMO_MODE=true ruby system_test.rb"
    end
  end

  desc "Run the sample app with live browser demo"
  task :browser do
    Dir.chdir("examples/sample_app") do
      sh "ruby run_demo.rb"
    end
  end

  desc "Run demo with custom delays (DELAY=3.0 START_DELAY=2.0)"
  task :slow do
    delay = ENV["DELAY"] || "3.0"
    start_delay = ENV["START_DELAY"] || "2.0"
    Dir.chdir("examples/sample_app") do
      sh "DEMO_MODE=true DEMO_DELAY=#{delay} DEMO_TEST_START_DELAY=#{start_delay} ruby system_test.rb"
    end
  end

  desc "Show all demo options"
  task :help do
    puts <<~HELP
      🎬 Capybara::Demo - Available Rake Tasks

      Main Tasks:
        rake test           - Run gem unit tests
        rake demo:test      - Run sample app tests (normal mode)
        rake demo:run       - Run sample app tests (demo mode)
        rake demo:browser   - Run live browser demo
        rake demo:slow      - Run demo with slower timing

      Custom Demo Options:
        rake demo:slow DELAY=3.0 START_DELAY=2.0
        
      Environment Variables:
        DEMO_MODE=true              - Enable demo mode
        DEMO_DELAY=2.0              - Action delay in seconds
        DEMO_TEST_START_DELAY=2.0   - Test start delay in seconds
        DEMO_NOTIFICATIONS=false    - Disable notifications
        
      Examples:
        rake demo:run                          # Basic demo
        DEMO_DELAY=1.0 rake demo:run          # Faster demo
        DEMO_NOTIFICATIONS=false rake demo:run # No notifications
    HELP
  end
end

# Examples namespace
namespace :examples do
  desc "Run the Ruby gem usage example"
  task :ruby do
    sh "ruby examples/real_gem_demo.rb"
  end

  desc "Open the HTML demo in browser"
  task :html do
    sh "open examples/simple_demo.html"
  end

  desc "List all examples"
  task :list do
    puts <<~EXAMPLES
      📁 Available Examples:

      Ruby Examples:
        rake examples:ruby     - Real gem functionality demo
        
      HTML Examples:
        rake examples:html     - Simple browser notification demo
        
      Sample App:
        rake demo:test         - System tests (normal mode)
        rake demo:run          - System tests (demo mode)
        rake demo:browser      - Live browser demo
    EXAMPLES
  end
end

task default: :test

# Add help task at top level
desc "Show all available tasks"
task :help do
  puts <<~HELP
    🎬 Capybara::Demo Gem

    Main Commands:
      rake test          - Run gem tests
      rake demo:help     - Demo options
      rake examples:list - Available examples
      
    Quick Start:
      rake demo:run      - See the gem in action!
  HELP
end
