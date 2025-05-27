# frozen_string_literal: true

module Capybara
  module Presenter
    class Configuration
      attr_reader :enabled, :delay, :notifications, :notification_position, :notification_style, :test_start_delay

      def initialize
        @enabled = ENV["PRESENTER_MODE"] == "true"
        @delay = ENV["PRESENTER_DELAY"]&.to_f || 2.0
        @notifications = ENV["PRESENTER_NOTIFICATIONS"] != "false"
        @notification_position = :center
        @notification_style = :system
        @test_start_delay = ENV["PRESENTER_TEST_START_DELAY"]&.to_f || 2.0
      end

      def enabled=(value)
        @enabled = !!value
      end

      def delay=(value)
        raise ArgumentError, "delay must be a positive number" unless value.is_a?(Numeric) && value > 0
        @delay = value.to_f
      end

      def notifications=(value)
        @notifications = !!value
      end

      def notification_position=(value)
        valid_positions = %i[top center bottom]
        unless valid_positions.include?(value)
          raise ArgumentError, "notification_position must be one of: #{valid_positions.join(", ")}"
        end
        @notification_position = value
      end

      def notification_style=(value)
        valid_styles = %i[system toast]
        unless valid_styles.include?(value)
          raise ArgumentError, "notification_style must be one of: #{valid_styles.join(", ")}"
        end
        @notification_style = value
      end

      def test_start_delay=(value)
        raise ArgumentError, "test_start_delay must be a positive number" unless value.is_a?(Numeric) && value >= 0
        @test_start_delay = value.to_f
      end
    end
  end
end