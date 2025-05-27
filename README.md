# Capybara::Presenter

Transform your Capybara system tests into polished presentations with automatic delays and browser notifications. Perfect for creating professional test recordings and demos.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capybara-presenter', group: :test
```

Then run:

```bash
bundle install
```

## Usage

### Basic Setup

Include the module in your test class:

```ruby
require 'capybara/presenter'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Capybara::Presenter
  
  # Disable parallel testing in presenter mode
  parallelize(workers: 1) if ENV["PRESENTER_MODE"] == "true"
end
```

### Running Tests in Presenter Mode

```bash
# Enable presenter mode
PRESENTER_MODE=true bundle exec rails test:system

# Customize timing
PRESENTER_MODE=true PRESENTER_DELAY=1.5 bundle exec rails test:system

# Disable notifications
PRESENTER_MODE=true PRESENTER_NOTIFICATIONS=false bundle exec rails test:system
```

### In Your Tests

```ruby
test "user registration" do
  visit new_user_registration_path
  
  fill_in "Email", with: "user@example.com"
  fill_in "Password", with: "password123"
  presenter_milestone("Form Complete", "All fields filled")
  
  click_button "Sign up"
  presenter_milestone("Success", "User registered successfully")
  
  assert_text "Welcome!"
end
```

## API

- `presenter_mode?` - Check if presenter mode is enabled
- `presenter_delay(seconds)` - Add custom delay
- `presenter_notification(title, message)` - Show browser notification
- `presenter_milestone(title, message)` - Show milestone notification

## Configuration

```ruby
Capybara::Presenter.configure do |config|
  config.enabled = ENV['PRESENTER_MODE'] == 'true'
  config.delay = 2.0
  config.notifications = true
  config.notification_position = :center  # :top, :center, :bottom
end
```

## Environment Variables

- `PRESENTER_MODE=true` - Enable presenter mode
- `PRESENTER_DELAY=2.0` - Action delay in seconds
- `PRESENTER_TEST_START_DELAY=2.0` - Delay before each test
- `PRESENTER_NOTIFICATIONS=false` - Disable notifications

## Browser Setup

For notifications to appear, use a non-headless driver:

```ruby
if ENV["PRESENTER_MODE"] == "true"
  driven_by :selenium, using: :chrome
else
  driven_by :selenium, using: :headless_chrome
end
```

## Examples

```bash
# See the gem in action
rake presenter:run

# View all options
rake presenter:help
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).