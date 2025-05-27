# frozen_string_literal: true

module Capybara
  module Presenter
    module CapybaraExtensions
      WRAPPED_METHODS = %i[visit click_button click_link click_on fill_in select choose check uncheck attach_file].freeze

      def setup_demo_delays
        return unless demo_mode?
        return if self.class.instance_variable_get(:@demo_delays_setup)
        
        self.class.instance_variable_set(:@demo_delays_setup, true)

        WRAPPED_METHODS.each do |action|
          next if respond_to?(:"#{action}_without_demo")

          # Create alias for original method
          self.class.alias_method :"#{action}_without_demo", action

          # Override the method with demo delays
          self.class.define_method(action) do |*args, **kwargs, &block|
            if demo_mode?
              log_demo_action(action, args.first)
              
              # Pre-action delay
              case action
              when :click_button, :click_link, :click_on
                demo_delay(0.3)
              when :fill_in, :select, :choose, :check, :uncheck
                demo_delay(0.2)
              when :visit
                demo_delay(0.5)
              when :attach_file
                demo_delay(0.3)
              end
            end

            # Execute the original action
            result = send(:"#{action}_without_demo", *args, **kwargs, &block)

            # Post-action delay for actions that trigger page changes
            if demo_mode? && [:click_button, :click_link, :click_on, :visit].include?(action)
              demo_delay(0.8)
            end

            result
          end
        end
      end

      private

      def log_demo_action(action, target)
        return unless demo_mode?

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
    end
  end
end