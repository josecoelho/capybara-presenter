# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Input sanitization for JavaScript injection prevention in notifications
- Environment variable validation with proper error handling and warnings
- Comprehensive development infrastructure (CI, RuboCop, pre-commit hooks)
- Support for presenter mode with visual notifications and delays
- Automatic delays between Capybara actions for better presentations
- Browser notifications for test milestones and progress
- Configurable notification positions (top, center, bottom)
- Sample application demonstrating gem functionality

### Changed
- Renamed gem from `capybara-demo` to `capybara-presenter` for clarity
- Renamed API methods from `demo_*` to `presenter_*` for consistency
- Renamed environment variables from `DEMO_*` to `PRESENTER_*`
- Updated all documentation and examples to use presenter terminology
- **BREAKING**: Raised minimum Ruby version from 3.1.0 to 3.2.0 for selenium-webdriver compatibility

### Security
- Added proper input sanitization to prevent XSS attacks in notifications
- Implemented safe HTML and JavaScript escaping for user content

### Development
- Added GitHub Actions CI for Ruby 3.1, 3.2, and 3.3
- Configured RuboCop with minimal overrides for code quality
- Set up Lefthook for pre-commit hooks (RuboCop and tests)
- Removed unused RSpec dependency in favor of Minitest
- Added proper .gitignore for generated files

## [0.1.0] - 2025-05-27

### Added
- Initial release of Capybara::Presenter gem
- Basic presenter mode functionality
- Configuration system with environment variable support
- Integration with Capybara test framework
- Documentation and examples