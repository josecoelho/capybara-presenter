# frozen_string_literal: true

module Capybara
  module Presenter
    module Delays
      def demo_delay(seconds = nil)
        return unless demo_mode?
        sleep(seconds || demo_delay_duration)
      end
    end
  end
end