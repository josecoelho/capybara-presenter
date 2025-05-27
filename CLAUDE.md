# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Testing
- `rake test` - Run gem unit tests
- `rake presenter:test` - Run sample app system tests
- `bundle exec ruby test/test_capybara_demo.rb` - Run specific test file

### Development Workflow
- `bin/console` - Start IRB console with gem loaded
- `bundle exec rubocop` - Run linting (enforced via pre-commit hooks)
- `bundle exec rake install` - Install gem locally for testing
- `bundle exec rake build` - Build gem package

### Demo/Presentation Commands
- `rake presenter:run` - Run live demo with browser automation
- `rake presenter:browser` - Run browser-only demo
- `rake presenter:help` - Show all available presenter options

## Architecture Overview

**Capybara::Presenter** is a Ruby gem that transforms standard Capybara system tests into presentation-ready demos. The gem operates by:

1. **Environment-based activation**: Only active when `PRESENTER_MODE=true`
2. **Zero overhead when disabled**: No performance impact in regular test runs
3. **Visual feedback**: Displays notifications in browser during test execution
4. **Configurable timing**: Adds delays between actions for recording-friendly pacing

### Core Components

- **Main module** (`lib/capybara/presenter.rb`): Entry point and configuration setup
- **Configuration** (`lib/capybara/presenter/configuration.rb`): Global settings management
- **Delays** (`lib/capybara/presenter/delays.rb`): Timing control between actions
- **Notifications** (`lib/capybara/presenter/notifications.rb`): Browser notification system
- **Capybara Extensions** (`lib/capybara/presenter/capybara_extensions.rb`): Monkey-patches Capybara methods

### Key Patterns

- **Method wrapping**: Core functionality wraps existing Capybara methods without breaking existing tests
- **JavaScript injection**: Notifications are displayed via injected JavaScript in the browser
- **Configuration precedence**: Environment variables override global configuration
- **Sample app**: Complete working example in `examples/sample_app/` using Sinatra

### Development Notes

- **Ruby version**: Requires >= 3.2.0
- **Dependencies**: Capybara >= 3.0, Selenium >= 4.0
- **Testing**: Uses Minitest with comprehensive mocking for browser interactions
- **Code quality**: RuboCop enforced via Lefthook pre-commit hooks