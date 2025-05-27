# Capybara::Presenter

Transform your Capybara system tests into polished presentations with automatic delays, browser notifications, and visual cues. Perfect for creating professional test recordings, demos, and documentation videos.

## Features

- 🎬 **Demo Mode Toggle** - Enable/disable via environment variables or configuration
- ⏱️ **Automatic Delays** - Configurable delays between Capybara actions for recording-friendly pacing
- 🔔 **Browser Notifications** - Visual notifications displayed in the browser during tests
- 📋 **Milestone Markers** - Special notifications for marking test steps
- 🎨 **Customizable Styling** - System-style or toast notifications with positioning options
- 🛡️ **Zero Overhead** - No performance impact when demo mode is disabled

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capybara-presenter', group: :test
```

And then execute:

    $ bundle install

## Usage

### Basic Setup

Include the module in your system test base class:

```ruby
# test/application_system_test_case.rb
require 'capybara/presenter'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Capybara::Presenter
  
  # Disable parallel testing in demo mode for sequential playback
  if ENV["DEMO_MODE"] == "true"
    parallelize(workers: 1)
  end
  
  # Your existing configuration...
end
```

### Configuration

Configure demo mode in your test helper or initializer:

```ruby
Capybara::Presenter.configure do |config|
  config.enabled = ENV['DEMO_MODE'] == 'true'
  config.delay = ENV['DEMO_DELAY']&.to_f || 2.0
  config.notifications = ENV['DEMO_NOTIFICATIONS'] != 'false'
  config.notification_position = :center  # :top, :center, :bottom
  config.notification_style = :system     # :system, :toast
end
```

### Environment Variables

Control demo mode via environment variables:

```bash
# Enable demo mode with default settings
DEMO_MODE=true bundle exec rails test:system

# Customize delay timing
DEMO_MODE=true DEMO_DELAY=1.5 bundle exec rails test:system

# Customize test start delay (pause before each test begins)
DEMO_MODE=true DEMO_TEST_START_DELAY=3.0 bundle exec rails test:system

# Disable notifications but keep delays
DEMO_MODE=true DEMO_NOTIFICATIONS=false bundle exec rails test:system
```

### In Your Tests

```ruby
class UsersSystemTest < ApplicationSystemTestCase
  test "user registration flow" do
    visit new_user_registration_path
    demo_notification("Starting Test", "Testing user registration flow")
    
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password123"
    demo_milestone("Form Complete", "All fields filled")
    
    click_button "Sign up"
    demo_milestone("Registration Complete", "User successfully registered")
    
    assert_text "Welcome!"
  end
end
```

### Automatic Action Delays

When demo mode is enabled, the gem automatically adds delays to common Capybara actions:

- `visit` - 0.5s pre-action, 0.8s post-action
- `click_button`, `click_link`, `click_on` - 0.3s pre-action, 0.8s post-action  
- `fill_in`, `select`, `choose`, `check`, `uncheck` - 0.2s pre-action
- `attach_file` - 0.3s pre-action

Enable automatic delays by calling `setup_demo_delays` in your test setup:

```ruby
setup do
  setup_demo_delays if demo_mode?
end
```

## API Reference

### Configuration Methods

- `Capybara::Presenter.configure { |config| ... }` - Configure the gem
- `Capybara::Presenter.reset_configuration!` - Reset to defaults

### Instance Methods

- `demo_mode?` - Returns true if demo mode is enabled
- `demo_delay(seconds = nil)` - Add a delay (uses configured delay if no argument)
- `demo_notification(title, message = nil, type: :info, duration: 4000)` - Show browser notification
- `demo_milestone(title, message = nil)` - Show milestone notification with longer duration
- `setup_demo_delays` - Enable automatic delays for Capybara actions

### Configuration Options

- `enabled` (boolean) - Enable/disable demo mode
- `delay` (float) - Default delay duration in seconds
- `notifications` (boolean) - Enable/disable browser notifications
- `notification_position` (:top, :center, :bottom) - Where to show notifications
- `notification_style` (:system, :toast) - Notification appearance style
- `test_start_delay` (float) - Delay at the beginning of each test (default: 2.0s)

## Browser Setup

The gem works with your existing Capybara driver configuration. For notifications to appear:

### Recommended Setup
```ruby
# For demo mode, use a non-headless driver
if ENV["DEMO_MODE"] == "true"
  driven_by :selenium, using: :chrome, screen_size: [1920, 1080]
else
  driven_by :selenium, using: :headless_chrome
end
```

### Browser Compatibility
- ✅ Chrome/Chromium (recommended for recordings)
- ✅ Firefox  
- ✅ Safari
- ✅ Any Selenium-compatible browser

**Important:** Notifications only appear in non-headless browsers. The gem gracefully handles missing browser access or JavaScript errors by falling back to console output only.

## Recording Tips

For best results when recording demos:

1. Use non-headless browser: Set `driven_by :selenium, using: :chrome`
2. Larger screen size: `screen_size: [1920, 1080]`
3. Disable animations in CSS for consistent timing
4. Use milestone notifications to mark important steps

## Examples

### Quick Start
```bash
# See the gem in action immediately
rake demo:run

# Run all available demos
rake examples:list
rake demo:help
```

### Available Examples
- **Sample App** - Complete Capybara test suite with real browser automation
- **Ruby Demo** - Shows actual gem functionality without browser
- **HTML Demo** - Visual browser notification examples

Check out the `examples/` directory for all source code.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/josecoelho/capybara-presenter.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).