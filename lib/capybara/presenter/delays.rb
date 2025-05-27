# frozen_string_literal: true

module Capybara
  module Presenter
    # Provides methods for adding configurable delays during test execution.
    # These delays make tests more suitable for recording and presentations.
    module Delays
      def presenter_delay(seconds = nil)
        return unless presenter_mode?

        sleep(seconds || presenter_delay_duration)
      end
    end
  end
end
