# frozen_string_literal: true

module Capybara
  module Presenter
    module Delays
      def presenter_delay(seconds = nil)
        return unless presenter_mode?
        sleep(seconds || presenter_delay_duration)
      end
    end
  end
end