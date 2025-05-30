# Capybara::Presenter

Transform your Capybara system tests into a presentations with automatic delays and browser notifications. Perfect for creating test recordings and demos.

I had this in a project and it helps me give quick updates about the progress of a feature. I like to [communicate often](https://josecoelho.com/Software-Engineer/Communicate-often), the easier, the better. Decided to extract it to a gem with some help from Claude. I hope it's useful for you as well. :)

![Demo](./examples/presenter.gif)

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

### Complete Setup

**1. Include the module in your test class:**

```ruby
require 'capybara/presenter'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Capybara::Presenter
  
  # Disable parallel testing in presenter mode for sequential execution
  parallelize(workers: 1) if ENV["PRESENTER_MODE"] == "true"
  
  # Configure browser driver for presenter mode
  if ENV["PRESENTER_MODE"] == "true"
    driven_by :selenium, using: :chrome, screen_size: [1920, 1080]
  else
    driven_by :selenium, using: :headless_chrome
  end
  
  # Add test start notifications and automatic delays
  setup do
    if presenter_mode?
      presenter_test_start_notification(self.class, @NAME)
      setup_presenter_delays
    end
  end
end
```

**2. For Minitest users, also add to your individual test classes:**

```ruby
class UsersSystemTest < ApplicationSystemTestCase
  # Test methods automatically get start notifications
end
```

**3. For RSpec users:**

```ruby
RSpec.configure do |config|
  config.include Capybara::Presenter, type: :system
  
  config.before(:each, type: :system) do
    if presenter_mode?
      presenter_test_start_notification(self.class, example.description)
      setup_presenter_delays
    end
  end
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
