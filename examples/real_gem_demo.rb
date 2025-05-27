#!/usr/bin/env ruby
# frozen_string_literal: true

# This demonstrates the ACTUAL capybara-demo gem functionality
# (Not a fake HTML simulation)

require_relative "../lib/capybara/demo"

puts "🎬 REAL Capybara::Demo Gem Demonstration"
puts "=" * 50

# Configure the gem
Capybara::Demo.configure do |config|
  config.enabled = true
  config.delay = 1.0
  config.notifications = true
  config.notification_position = :center
end

puts "✅ Gem configured:"
puts "   - Demo mode: #{Capybara::Demo.configuration.enabled}"
puts "   - Delay: #{Capybara::Demo.configuration.delay}s"
puts "   - Notifications: #{Capybara::Demo.configuration.notifications}"
puts "   - Position: #{Capybara::Demo.configuration.notification_position}"

# Create a test class that includes the gem
class ActualSystemTest
  include Capybara::Demo

  def initialize
    puts "\n🔧 Test class created with Capybara::Demo included"
    puts "   - demo_mode?: #{demo_mode?}"
    puts "   - demo_delay_duration: #{demo_delay_duration}s"
    puts "   - demo_notifications_enabled?: #{demo_notifications_enabled?}"
  end

  def run_real_demo
    puts "\n🚀 Starting REAL gem demonstration..."
    
    puts "\n1. Testing demo_delay method:"
    print "   Delaying for 0.5 seconds... "
    start_time = Time.now
    demo_delay(0.5)
    end_time = Time.now
    puts "✅ (took #{(end_time - start_time).round(2)}s)"

    puts "\n2. Testing demo_notification method:"
    puts "   → demo_notification('Test Step', 'This would show in browser')"
    demo_notification("Test Step", "This would show in browser if we had a real page")
    puts "   ✅ Notification method called (no browser = graceful fallback)"

    puts "\n3. Testing demo_milestone method:"
    print "   → demo_milestone('Milestone', 'Important step complete') "
    demo_milestone("Milestone", "Important step complete")
    puts "✅ (includes 1s delay)"

    puts "\n4. Testing configuration changes:"
    original_enabled = Capybara::Demo.configuration.enabled
    Capybara::Demo.configuration.enabled = false
    
    puts "   → Disabling demo mode..."
    puts "   → demo_mode? = #{demo_mode?}"
    
    print "   → demo_delay(0.5) with disabled mode... "
    start_time = Time.now
    demo_delay(0.5)
    end_time = Time.now
    puts "✅ (took #{(end_time - start_time).round(3)}s - no delay when disabled)"
    
    # Restore
    Capybara::Demo.configuration.enabled = original_enabled

    puts "\n🎉 Real gem demonstration complete!"
    puts "\nThis shows the ACTUAL capybara-demo gem working,"
    puts "not a simulation. In real Capybara tests, notifications"
    puts "would appear in the browser window."
  end
end

# Run the demonstration
test_instance = ActualSystemTest.new
test_instance.run_real_demo

puts "\n" + "=" * 50
puts "✨ Want to see browser notifications? Use this gem in"
puts "   real Capybara system tests with a browser driver!"