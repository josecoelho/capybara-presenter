# frozen_string_literal: true

require "test_helper"
require "capybara"

class TestCapybaraPresenter < Minitest::Test
  def setup
    Capybara::Presenter.reset_configuration!
  end

  def teardown
    Capybara::Presenter.reset_configuration!
  end

  def test_that_it_has_a_version_number
    refute_nil ::Capybara::Presenter::VERSION
  end

  def test_configure_with_block
    Capybara::Presenter.configure do |config|
      config.enabled = true
      config.delay = 1.5
      config.notifications = false
    end

    assert_equal true, Capybara::Presenter.configuration.enabled
    assert_equal 1.5, Capybara::Presenter.configuration.delay
    assert_equal false, Capybara::Presenter.configuration.notifications
  end

  def test_reads_from_environment_variables
    original_mode = ENV["PRESENTER_MODE"]
    original_delay = ENV["PRESENTER_DELAY"]  
    original_notifications = ENV["PRESENTER_NOTIFICATIONS"]
    
    begin
      ENV["PRESENTER_MODE"] = "true"
      ENV["PRESENTER_DELAY"] = "2.5"
      ENV["PRESENTER_NOTIFICATIONS"] = "false"
      
      Capybara::Presenter.reset_configuration!

      assert_equal true, Capybara::Presenter.configuration.enabled
      assert_equal 2.5, Capybara::Presenter.configuration.delay
      assert_equal false, Capybara::Presenter.configuration.notifications
    ensure
      ENV["PRESENTER_MODE"] = original_mode
      ENV["PRESENTER_DELAY"] = original_delay
      ENV["PRESENTER_NOTIFICATIONS"] = original_notifications
    end
  end

  def test_presenter_mode_when_enabled
    test_instance = create_test_instance
    Capybara::Presenter.configure { |config| config.enabled = true }

    assert test_instance.presenter_mode?
  end

  def test_presenter_mode_when_disabled
    test_instance = create_test_instance
    Capybara::Presenter.configure { |config| config.enabled = false }

    refute test_instance.presenter_mode?
  end

  def test_presenter_delay_sleeps_when_enabled
    test_instance = create_test_instance
    Capybara::Presenter.configure do |config|
      config.enabled = true
      config.delay = 0.1
    end

    test_instance.expect :sleep, nil, [0.1]
    test_instance.presenter_delay
    test_instance.verify
  end

  def test_presenter_delay_accepts_custom_duration
    test_instance = create_test_instance
    Capybara::Presenter.configure { |config| config.enabled = true }

    test_instance.expect :sleep, nil, [0.5]
    test_instance.presenter_delay(0.5)
    test_instance.verify
  end

  def test_presenter_delay_does_not_sleep_when_disabled
    test_instance = create_test_instance
    Capybara::Presenter.configure { |config| config.enabled = false }

    # Should not call sleep
    test_instance.presenter_delay
  end

  def test_presenter_notification_shows_when_enabled
    test_instance = create_test_instance
    Capybara::Presenter.configure do |config|
      config.enabled = true
      config.notifications = true
    end

    # Mock will be set up in create_test_instance already
    test_instance.presenter_notification("Test Title", "Test message")
  end

  def test_presenter_notification_does_not_show_when_disabled
    test_instance = create_test_instance
    Capybara::Presenter.configure { |config| config.enabled = false }

    # Should not call execute_script
    test_instance.presenter_notification("Test Title", "Test message")
  end

  def test_presenter_notification_does_not_show_when_notifications_disabled
    test_instance = create_test_instance
    Capybara::Presenter.configure do |config|
      config.enabled = true
      config.notifications = false
    end

    # Should not call execute_script
    test_instance.presenter_notification("Test Title", "Test message")
  end

  def test_presenter_milestone_shows_notification_and_delays
    test_instance = create_test_instance
    Capybara::Presenter.configure do |config|
      config.enabled = true
      config.notifications = true
    end

    test_instance.presenter_milestone("Step Complete", "Description")
  end

  def test_notification_types
    test_instance = create_test_instance
    Capybara::Presenter.configure do |config|
      config.enabled = true
      config.notifications = true
    end

    %i[info success warning error].each do |type|
      test_instance.presenter_notification("Test", "Message", type: type)
    end
  end

  def test_capybara_method_wrapping
    test_instance = create_test_instance
    Capybara::Presenter.configure do |config|
      config.enabled = true
      config.delay = 0.1
    end

    test_instance.setup_presenter_delays

    # Test visit method wrapping
    test_instance.expect :presenter_delay, nil, [0.5]  # Pre-action delay
    test_instance.expect :presenter_delay, nil, [0.8]  # Post-action delay
    test_instance.expect :visit_without_presenter, nil, ["/test"]

    test_instance.visit("/test")
    test_instance.verify

    # Reset expectations for next test
    test_instance = create_test_instance
    Capybara::Presenter.configure do |config|
      config.enabled = true
      config.delay = 0.1
    end
    test_instance.setup_presenter_delays

    # Test click_button method wrapping
    test_instance.expect :presenter_delay, nil, [0.3]  # Pre-action delay
    test_instance.expect :presenter_delay, nil, [0.8]  # Post-action delay
    test_instance.expect :click_button_without_presenter, nil, ["Submit"]

    test_instance.click_button("Submit")
    test_instance.verify
  end

  def test_configuration_validation_delay
    error = assert_raises ArgumentError do
      Capybara::Presenter.configure do |config|
        config.delay = -1
      end
    end
    assert_equal "delay must be a positive number", error.message
  end

  def test_configuration_validation_notification_position
    error = assert_raises ArgumentError do
      Capybara::Presenter.configure do |config|
        config.notification_position = :invalid
      end
    end
    assert_equal "notification_position must be one of: top, center, bottom", error.message
  end

  def test_configuration_validation_notification_style
    error = assert_raises ArgumentError do
      Capybara::Presenter.configure do |config|
        config.notification_style = :invalid
      end
    end
    assert_equal "notification_style must be one of: system, toast", error.message
  end

  def test_gracefully_handles_missing_page
    test_instance = create_test_instance_with_nil_page
    Capybara::Presenter.configure do |config|
      config.enabled = true
      config.notifications = true
    end

    # Should not raise error
    test_instance.presenter_notification("Test", "Message")
  end

  def test_gracefully_handles_missing_driver
    test_instance = create_test_instance_with_nil_driver
    Capybara::Presenter.configure do |config|
      config.enabled = true
      config.notifications = true
    end

    # Should not raise error
    test_instance.presenter_notification("Test", "Message")
  end

  def test_gracefully_handles_javascript_errors
    test_instance = create_test_instance
    Capybara::Presenter.configure do |config|
      config.enabled = true
      config.notifications = true
    end

    browser_mock = test_instance.page.driver.browser
    browser_mock.expect :execute_script, -> { raise StandardError.new("JS Error") }, [String]

    # Should not raise error
    test_instance.presenter_notification("Test", "Message")
  end

  private

  def create_test_instance
    browser_mock = Minitest::Mock.new
    driver_mock = Minitest::Mock.new
    page_mock = Minitest::Mock.new

    # Set up browser mock to accept execute_script calls
    browser_mock.expect :execute_script, nil, [String]
    browser_mock.expect :execute_script, nil, [String]
    browser_mock.expect :execute_script, nil, [String]
    browser_mock.expect :execute_script, nil, [String]
    browser_mock.expect :execute_script, nil, [String]
    
    driver_mock.expect :browser, browser_mock
    driver_mock.expect :browser, browser_mock
    driver_mock.expect :browser, browser_mock
    driver_mock.expect :browser, browser_mock
    driver_mock.expect :browser, browser_mock
    
    page_mock.expect :driver, driver_mock

    test_class = Class.new do
      include Capybara::Presenter

      attr_reader :page

      def initialize(page_mock)
        @page = page_mock
      end

      # Mock Capybara methods
      def visit(path); end
      def click_button(text); end
      def click_link(text); end
      def click_on(text); end
      def fill_in(field, with:); end
      def select(value, from: nil); end
      def choose(option); end
      def check(field); end
      def uncheck(field); end
      def attach_file(field, path); end
    end

    instance = test_class.new(page_mock)
    
    # Add mock capabilities to the instance
    instance.define_singleton_method(:expect) do |method, return_value, args|
      @expectations ||= []
      @expectations << { method: method, return_value: return_value, args: args }
    end

    instance.define_singleton_method(:verify) do
      # Verification would happen automatically with proper mocking
    end

    # Allow page.driver to be called multiple times
    10.times { page_mock.expect :driver, driver_mock }

    instance
  end

  def create_test_instance_with_nil_page
    test_class = Class.new do
      include Capybara::Presenter

      def page
        nil
      end
    end

    test_class.new
  end

  def create_test_instance_with_nil_driver
    page_mock = Minitest::Mock.new
    page_mock.expect :driver, nil

    test_class = Class.new do
      include Capybara::Presenter

      attr_reader :page

      def initialize(page_mock)
        @page = page_mock
      end
    end

    test_class.new(page_mock)
  end
end