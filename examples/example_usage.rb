#!/usr/bin/env ruby
# frozen_string_literal: true

# Example usage of capybara-demo gem
require_relative "lib/capybara/demo"

# Configure demo mode
Capybara::Demo.configure do |config|
  config.enabled = true
  config.delay = 1.0
  config.notifications = true
  config.notification_position = :center
end

# Example test class that uses the demo functionality
class DemoSystemTest
  include Capybara::Demo

  def initialize
    puts "🎬 Demo mode enabled: #{demo_mode?}"
    puts "⏱️  Delay duration: #{demo_delay_duration}s"
    puts "🔔 Notifications: #{demo_notifications_enabled?}"
  end

  def run_demo
    puts "\n🚀 Starting demo test..."
    
    # Demo delays
    puts "Testing demo delays..."
    demo_delay(0.5)
    puts "✅ Demo delay works!"

    # Demo notifications would work if we had a browser
    puts "Demo notifications would appear in browser during real tests"
    
    puts "\n🎉 Demo completed successfully!"
  end

  # Mock some Capybara methods for demonstration
  def visit(path); puts "📍 Visiting: #{path}"; end
  def click_button(text); puts "🖱️  Clicking button: #{text}"; end
  def fill_in(field, with:); puts "⌨️  Filling '#{field}' with: #{with}"; end
end

# Run the demo
demo_test = DemoSystemTest.new
demo_test.run_demo