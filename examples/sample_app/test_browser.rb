#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "test_helper"

puts "🔍 Testing browser opening..."

# Force demo mode
ENV["DEMO_MODE"] = "true"

class BrowserTest < SystemTestCase
  def test_browser_opens
    puts "🌐 Visiting homepage..."
    visit "/"
    
    puts "✅ Page title: #{page.title}"
    puts "✅ Page has text: #{has_text?('Welcome to Sample App')}"
    
    demo_notification("Browser Test", "This notification should appear in Chrome!")
    demo_milestone("Browser Working", "Chrome browser opened successfully")
    
    puts "⏸️  Pausing for 5 seconds so you can see the browser..."
    sleep(5)
    
    puts "🎉 Browser test complete!"
  end
end

# Run the test
test = BrowserTest.new("test_browser_opens")
test.setup
test.test_browser_opens
test.teardown