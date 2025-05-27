# frozen_string_literal: true

require_relative "presenter/version"
require_relative "presenter/configuration"
require_relative "presenter/notifications"
require_relative "presenter/delays"
require_relative "presenter/capybara_extensions"

module Capybara
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
      
      # Show setup guidance when demo mode is enabled
      if configuration.enabled
        show_setup_guidance
      end
    end

    def self.show_setup_guidance
      puts <<~GUIDANCE
        
        🎬 Capybara::Presenter Setup Guidance:
        
        For browser notifications to appear:
        1. Use a non-headless driver (Chrome, Firefox, Safari)
        2. Ensure browser opens visibly 
        3. Disable parallel testing: parallelize(workers: 1)
        
        Environment variables:
        - DEMO_DELAY=2.0 (action delays)
        - DEMO_TEST_START_DELAY=2.0 (pause before each test)
        - DEMO_NOTIFICATIONS=false (disable notifications)
        
        💡 This gem works with your existing Capybara driver configuration
        
      GUIDANCE
    end

    module ClassMethods
      def demo_mode?
        Capybara::Presenter.configuration.enabled
      end

      def demo_delay_duration
        Capybara::Presenter.configuration.delay
      end

      def demo_notifications_enabled?
        Capybara::Presenter.configuration.notifications
      end
    end

    module InstanceMethods
      include Notifications
      include Delays
      include CapybaraExtensions

      def demo_mode?
        self.class.demo_mode?
      end

      def demo_delay_duration
        self.class.demo_delay_duration
      end

      def demo_notifications_enabled?
        self.class.demo_notifications_enabled?
      end
    end
  end
end