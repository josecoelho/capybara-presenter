# frozen_string_literal: true

require "minitest/autorun"
require "capybara"
require "capybara/minitest"
require "selenium-webdriver"

# Load our gem (adjust path for development)
$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
require "capybara/demo"

# Configure Capybara
Capybara.app = Rack::Builder.parse_file(File.expand_path("config.ru", __dir__))
Capybara.server = :puma, { Silent: true }

# Configure driver based on demo mode
if ENV["DEMO_MODE"] == "true"
  puts "🎬 Demo mode: Attempting to open Chrome browser for notifications..."
  
  # Register the Chrome driver
  Capybara.register_driver :demo_chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    
    # Chrome options for demo recording
    options.add_argument("--disable-extensions")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-infobars")
    options.add_argument("--disable-save-password-bubble")
    options.add_argument("--window-size=1200,800")
    
    begin
      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    rescue => e
      puts "❌ Chrome driver failed: #{e.message}"
      puts "💡 Try: brew install chromedriver (macOS) or install Chrome browser"
      raise e
    end
  end
  
  begin
    Capybara.default_driver = :demo_chrome
    Capybara.current_driver = :demo_chrome
    puts "✅ Chrome browser ready for demo notifications"
  rescue => e
    puts "⚠️  Falling back to rack_test (no browser notifications)"
    puts "   Error: #{e.message}"
    Capybara.default_driver = :rack_test
  end
else
  # Use rack_test for fast testing (no browser needed)
  Capybara.default_driver = :rack_test
  puts "🏃 Fast mode: Using rack_test driver"
end

# Configure our gem
Capybara::Demo.configure do |config|
  config.enabled = ENV["DEMO_MODE"] == "true"
  config.delay = ENV["DEMO_DELAY"]&.to_f || 2.0
  config.notifications = ENV["DEMO_NOTIFICATIONS"] != "false"
  config.notification_position = :center
  config.test_start_delay = ENV["DEMO_TEST_START_DELAY"]&.to_f || 2.0
end

class SystemTestCase < Minitest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  include Capybara::Demo

  def setup
    setup_demo_delays if demo_mode?
    
    if demo_mode?
      puts "🎬 Demo mode: ON"
      # Show test start notification with 2s delay
      demo_test_start_notification(self.class, name)
    end
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end