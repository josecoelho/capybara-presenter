#!/usr/bin/env ruby
# frozen_string_literal: true

# Simple demo runner that ensures browser opens
require_relative "test_helper"

puts "🎬 Capybara::Demo - Live Browser Demo"
puts "=" * 40

# Force selenium driver for visual demo
puts "🚀 Configuring Chrome browser for visual demo..."

Capybara.register_driver :demo_selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--disable-extensions")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1200,800")
  options.add_argument("--window-position=100,100")
  
  driver = Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  puts "✅ Chrome driver created successfully"
  driver
end

Capybara.default_driver = :demo_selenium
Capybara.current_driver = :demo_selenium

puts "🌐 Starting Puma server..."
# Ensure the server is running
Capybara.server = :puma, { Silent: true }

# Configure for demo
Capybara::Demo.configure do |config|
  config.enabled = true
  config.delay = 2.0
  config.notifications = true
  config.notification_position = :center
end

class LiveDemo
  include Capybara::DSL
  include Capybara::Demo

  def run_browser_demo
    puts "\n🚀 Starting live browser demo..."
    puts "📋 This will open Chrome and show real notifications"
    
    setup_demo_delays
    
    demo_notification("🎬 Demo Starting", "Watch the browser for notifications!")
    
    visit "/"
    demo_milestone("Homepage Loaded", "Successfully navigated to sample app")
    
    click_link "Sign Up"
    demo_milestone("Form Loaded", "Registration form is ready")
    
    fill_in "Email", with: "demo@example.com"
    demo_notification("Email Entered", "User typed email address")
    
    fill_in "Password", with: "demopassword123"
    demo_milestone("Form Complete", "All fields filled successfully")
    
    click_button "Create Account"
    demo_notification("Form Submitted", "Processing registration...")
    
    demo_milestone("✅ Demo Complete", "Registration successful! Demo finished.")
    
    puts "\n🎉 Live demo completed!"
    puts "💡 The notifications appeared in the browser window"
    
    sleep(3) # Keep browser open briefly
  ensure
    Capybara.reset_sessions!
  end
end

begin
  demo = LiveDemo.new
  demo.run_browser_demo
rescue => e
  puts "❌ Demo failed: #{e.message}"
  puts "💡 Try: brew install chromedriver (if on macOS)"
  puts "💡 Or use: DEMO_MODE=true ruby system_test.rb"
end