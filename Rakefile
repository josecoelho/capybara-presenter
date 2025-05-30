# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

# Main gem tests
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/test_*.rb']
end

# Presenter and example tasks
# rubocop:disable Metrics/BlockLength
namespace :presenter do
  desc 'Run the sample app system tests in normal mode'
  task :test do
    Dir.chdir('examples/sample_app') do
      sh 'ruby system_test.rb'
    end
  end

  desc 'Run the sample app system tests in presenter mode'
  task :run do
    Dir.chdir('examples/sample_app') do
      sh 'PRESENTER_MODE=true ruby system_test.rb'
    end
  end

  desc 'Run presenter with custom delays (DELAY=3.0 START_DELAY=2.0)'
  task :slow do
    delay = ENV['DELAY'] || '3.0'
    start_delay = ENV['START_DELAY'] || '2.0'
    Dir.chdir('examples/sample_app') do
      sh "PRESENTER_MODE=true PRESENTER_DELAY=#{delay} PRESENTER_TEST_START_DELAY=#{start_delay} ruby system_test.rb"
    end
  end

  desc 'Show all presenter options'
  task :help do
    puts <<~HELP
      🎬 Capybara::Presenter - Available Rake Tasks

      Main Tasks:
        rake test               - Run gem unit tests
        rake presenter:test     - Run sample app tests (normal mode)
        rake presenter:run      - Run sample app tests (presenter mode)
        rake presenter:slow     - Run presenter with slower timing

      Custom Presenter Options:
        rake presenter:slow DELAY=3.0 START_DELAY=2.0
      #{'  '}
      Environment Variables:
        PRESENTER_MODE=true              - Enable presenter mode
        PRESENTER_DELAY=2.0              - Action delay in seconds
        PRESENTER_TEST_START_DELAY=2.0   - Test start delay in seconds
        PRESENTER_NOTIFICATIONS=false    - Disable notifications
      #{'  '}
      Examples:
        rake presenter:run                                  # Basic presenter
        PRESENTER_DELAY=1.0 rake presenter:run            # Faster presenter
        PRESENTER_NOTIFICATIONS=false rake presenter:run  # No notifications
    HELP
  end
end
# rubocop:enable Metrics/BlockLength

task default: :test

# Add help task at top level
desc 'Show all available tasks'
task :help do
  puts <<~HELP
    🎬 Capybara::Presenter Gem

    Main Commands:
      rake test              - Run gem tests
      rake presenter:help    - Presenter options
    #{'  '}
    Quick Start:
      rake presenter:run     - See the gem in action!
  HELP
end
