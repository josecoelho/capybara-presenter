# Sample App for Capybara::Demo

This is a minimal Rack application with real Capybara system tests to demonstrate the capybara-demo gem.

## Setup

```bash
cd examples/sample_app
bundle install
```

## Running Tests

### Normal Mode (headless, fast)
```bash
ruby system_test.rb
```

### Demo Mode (visible browser, with notifications)
```bash
DEMO_MODE=true ruby system_test.rb
```

### Custom Demo Settings
```bash
# Slower delays for recording
DEMO_MODE=true DEMO_DELAY=3.0 ruby system_test.rb

# Demo mode without notifications
DEMO_MODE=true DEMO_NOTIFICATIONS=false ruby system_test.rb
```

## What This Demonstrates

1. **Real Capybara tests** with actual browser automation
2. **capybara-demo gem integration** in a test suite
3. **Browser notifications** appearing during test execution
4. **Automatic delays** between Capybara actions
5. **Milestone markers** for important test steps

## The Tests

- `test_user_can_register_successfully` - Full user registration flow with demo notifications
- `test_registration_form_has_required_fields` - Form validation testing

Perfect for:
- Recording demo videos
- Understanding gem integration
- Testing the gem with real Capybara