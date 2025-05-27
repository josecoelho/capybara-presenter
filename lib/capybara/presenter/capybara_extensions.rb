# frozen_string_literal: true

module Capybara
  module Presenter
    # Extends Capybara methods with presentation features.
    # Wraps common Capybara actions to add delays and logging for better presentations.
    module CapybaraExtensions
      WRAPPED_METHODS = %i[visit click_button click_link click_on fill_in select choose check uncheck
                           attach_file].freeze

      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def setup_presenter_delays
        return unless presenter_mode?
        return if self.class.instance_variable_get(:@presenter_delays_setup)

        self.class.instance_variable_set(:@presenter_delays_setup, true)

        WRAPPED_METHODS.each do |action|
          next if respond_to?(:"#{action}_without_presenter")

          # Create alias for original method
          self.class.alias_method :"#{action}_without_presenter", action

          # Override the method with presenter delays
          self.class.define_method(action) do |*args, **kwargs, &block|
            if presenter_mode?
              log_presenter_action(action, args.first)

              # Pre-action delay
              case action
              when :click_button, :click_link, :click_on
                presenter_delay(0.3)
              when :fill_in, :select, :choose, :check, :uncheck
                presenter_delay(0.2)
              when :visit
                presenter_delay(0.5)
              when :attach_file
                presenter_delay(0.3)
              end
            end

            # Execute the original action
            result = send(:"#{action}_without_presenter", *args, **kwargs, &block)

            # Post-action delay for actions that trigger page changes
            presenter_delay(0.8) if presenter_mode? && %i[click_button click_link click_on visit].include?(action)

            result
          end
        end
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

      private

      # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def log_presenter_action(action, target)
        return unless presenter_mode?

        case action
        when :click_button, :click_link, :click_on
          puts "🖱️  Clicking: #{target}" if target
        when :fill_in
          puts "⌨️  Filling: #{target}" if target
        when :select, :choose, :check, :uncheck
          puts "☑️  Selecting: #{target}" if target
        when :visit
          puts "🌐 Navigating to: #{target}" if target
        when :attach_file
          puts "📎 Attaching file: #{target}" if target
        end
      end
      # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    end
  end
end
