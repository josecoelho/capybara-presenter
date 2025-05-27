# frozen_string_literal: true

require_relative 'presenter/version'
require_relative 'presenter/configuration'
require_relative 'presenter/notifications'
require_relative 'presenter/capybara_extensions'

module Capybara
  # Main module for the Capybara::Presenter gem.
  # Transforms standard Capybara system tests into presentation-ready demos
  # with visual notifications and configurable delays.
  module Presenter
    class Error < StandardError; end

    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration) if block_given?
      end

      def reset_configuration!
        @configuration = Configuration.new
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)

      # Show setup guidance when presenter mode is enabled
      return unless configuration.enabled

      show_setup_guidance
    end

    # rubocop:disable Metrics/MethodLength
    def self.show_setup_guidance
      puts <<~GUIDANCE

        🎬 Capybara::Presenter Setup Guidance:

        For browser notifications to appear:
        1. Use a non-headless driver (Chrome, Firefox, Safari)
        2. Ensure browser opens visibly#{' '}
        3. Disable parallel testing: parallelize(workers: 1)

        Environment variables:
        - PRESENTER_DELAY=2.0 (action delays)
        - PRESENTER_TEST_START_DELAY=2.0 (pause before each test)
        - PRESENTER_NOTIFICATIONS=false (disable notifications)

        💡 This gem works with your existing Capybara driver configuration

      GUIDANCE
    end
    # rubocop:enable Metrics/MethodLength

    # Class-level helper methods for checking presenter configuration.
    module ClassMethods
      def presenter_mode?
        Capybara::Presenter.configuration.enabled
      end

      def presenter_delay_duration
        Capybara::Presenter.configuration.delay
      end

      def presenter_notifications_enabled?
        Capybara::Presenter.configuration.notifications
      end
    end

    # Instance-level helper methods for checking presenter configuration.
    module InstanceMethods
      include Notifications
      include CapybaraExtensions

      def presenter_mode?
        self.class.presenter_mode?
      end

      def presenter_delay(seconds = nil)
        return unless presenter_mode?

        sleep(seconds || presenter_delay_duration)
      end

      def presenter_delay_duration
        self.class.presenter_delay_duration
      end

      def presenter_notifications_enabled?
        self.class.presenter_notifications_enabled?
      end
    end
  end
end
