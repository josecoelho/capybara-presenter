# Sample App for Capybara::Presenter

This is a minimal Rack application with real Capybara system tests to demonstrate the capybara-presenter gem.

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

### Presenter Mode (visible browser, with notifications)
```bash
PRESENTER_MODE=true ruby system_test.rb
```

### Custom Presenter Settings
```bash
# Slower delays for recording
PRESENTER_MODE=true PRESENTER_DELAY=3.0 ruby system_test.rb

# Presenter mode without notifications
PRESENTER_MODE=true PRESENTER_NOTIFICATIONS=false ruby system_test.rb
```

## What This Demonstrates

1. **Real Capybara tests** with actual browser automation
2. **capybara-presenter gem integration** in a test suite
3. **Browser notifications** appearing during test execution
4. **Automatic delays** between Capybara actions
5. **Milestone markers** for important test steps

## The Tests

- `test_user_can_register_successfully` - Full user registration flow with presenter notifications
- `test_registration_form_has_required_fields` - Form validation testing

Perfect for:
- Recording presentation videos
- Understanding gem integration
- Testing the gem with real Capybara