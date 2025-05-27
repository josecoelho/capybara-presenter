# frozen_string_literal: true

module Capybara
  module Presenter
    # Configuration class for Capybara::Presenter settings.
    # Manages global settings like delays, notifications, and environment variable parsing.
    class Configuration
      attr_reader :enabled, :delay, :notifications, :notification_position, :notification_style, :test_start_delay

      def initialize
        @enabled = ENV['PRESENTER_MODE'] == 'true'
        @delay = parse_float_env('PRESENTER_DELAY', 2.0)
        @notifications = ENV['PRESENTER_NOTIFICATIONS'] != 'false'
        @notification_position = :center
        @notification_style = :system
        @test_start_delay = parse_float_env('PRESENTER_TEST_START_DELAY', 2.0)
      end

      def enabled=(value)
        @enabled = !!value
      end

      def delay=(value)
        raise ArgumentError, 'delay must be a positive number' unless value.is_a?(Numeric) && value.positive?

        @delay = value.to_f
      end

      def notifications=(value)
        @notifications = !!value
      end

      def notification_position=(value)
        valid_positions = %i[top center bottom]
        unless valid_positions.include?(value)
          raise ArgumentError, "notification_position must be one of: #{valid_positions.join(', ')}"
        end

        @notification_position = value
      end

      def notification_style=(value)
        valid_styles = %i[system toast]
        unless valid_styles.include?(value)
          raise ArgumentError, "notification_style must be one of: #{valid_styles.join(', ')}"
        end

        @notification_style = value
      end

      def test_start_delay=(value)
        raise ArgumentError, 'test_start_delay must be a positive number' unless value.is_a?(Numeric) && value >= 0

        @test_start_delay = value.to_f
      end

      private

      # rubocop:disable Metrics/MethodLength
      def parse_float_env(env_var, default)
        value = ENV.fetch(env_var, nil)
        return default unless value

        begin
          parsed = Float(value)
          if parsed.negative?
            warn "Warning: #{env_var}=#{value} is negative, using default #{default}"
            default
          else
            parsed
          end
        rescue ArgumentError
          warn "Warning: #{env_var}=#{value} is not a valid number, using default #{default}"
          default
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
