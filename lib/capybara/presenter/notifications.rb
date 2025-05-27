# frozen_string_literal: true

module Capybara
  module Presenter
    module Notifications
      def presenter_notification(title, message = nil, type: :info, duration: 4000)
        return unless presenter_mode? && presenter_notifications_enabled?

        show_browser_notification(title, message, type, duration)
      end

      def presenter_milestone(title, message = nil)
        return unless presenter_mode?
        presenter_notification("📋 #{title}", message, type: :success, duration: 3000)
        presenter_delay(1.0)
      end

      def presenter_test_start_notification(test_class, test_method)
        return unless presenter_mode? && presenter_notifications_enabled?

        test_name = test_class.name.gsub(/Test$/, "")
        method_name = test_method.gsub(/^test_/, "").gsub(/_/, " ").split.map(&:capitalize).join(" ")

        presenter_notification("🧪 #{test_name}", "Running: #{method_name}", type: :info, duration: 8000)
        puts "📋 Starting test: #{test_name} - #{method_name}"
        presenter_delay(Capybara::Presenter.configuration.test_start_delay)
      end

      private

      def show_browser_notification(title, message, type, duration)
        return unless has_browser_access?

        begin
          page.driver.browser.execute_script(notification_javascript(title, message, type, duration))
        rescue => e
          # Gracefully handle JavaScript errors
          puts "Presenter notification failed: #{e.message}" if ENV["DEBUG"]
        end
      end

      def has_browser_access?
        respond_to?(:page) && 
        page&.respond_to?(:driver) && 
        page.driver&.respond_to?(:browser)
      end

      def notification_javascript(title, message, type, duration)
        position = notification_position_css
        <<~JS
          console.log('Presenter notification: #{title.gsub("'", "\\'")}');

          // Remove existing presenter notifications
          document.querySelectorAll('.presenter-notification').forEach(el => el.remove());

          // Create notification container if it doesn't exist
          let container = document.getElementById('presenter-notification-container');
          if (!container) {
            container = document.createElement('div');
            container.id = 'presenter-notification-container';
            container.style.cssText = `
              position: fixed;
              #{position}
              z-index: 10000;
              pointer-events: none;
              display: flex;
              flex-direction: column;
              align-items: center;
              gap: 12px;
            `;
            document.body.appendChild(container);
          }

          // Create notification element
          const notification = document.createElement('div');
          notification.className = 'presenter-notification';

          notification.style.cssText = `
            background: rgba(0, 0, 0, 0.5);
            color: white;
            padding: 32px 48px;
            border-radius: 8px;
            min-width: 700px;
            max-width: 900px;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            font-size: 22px;
            font-weight: 600;
            line-height: 1.3;
            text-align: center;
            transition: all 0.3s ease-in-out;
            pointer-events: auto;
          `;

          notification.innerHTML = `
            <div style="font-size: 26px; font-weight: 800; margin-bottom: #{message ? '12px' : '0'};">#{title.gsub('"', '&quot;').gsub("'", "\\'")}</div>
            #{message ? "<div style=\"font-size: 20px; font-weight: 500; opacity: 0.9;\">#{message.gsub('"', '&quot;').gsub("'", "\\'")}</div>" : ''}
          `;

          container.appendChild(notification);

          // Auto remove after duration
          setTimeout(() => {
            notification.style.opacity = '0';
            notification.style.transform = 'translateY(-10px)';
            setTimeout(() => {
              if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
              }
            }, 300);
          }, #{duration});

          // Click to dismiss
          notification.addEventListener('click', () => {
            notification.style.opacity = '0';
            notification.style.transform = 'translateY(-10px)';
            setTimeout(() => {
              if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
              }
            }, 300);
          });
        JS
      end

      def notification_position_css
        case Capybara::Presenter.configuration.notification_position
        when :top
          "top: 40px; left: 50%; transform: translateX(-50%);"
        when :center
          "top: 50%; left: 50%; transform: translate(-50%, -50%);"
        when :bottom
          "bottom: 40px; left: 50%; transform: translateX(-50%);"
        else
          "top: 40px; left: 50%; transform: translateX(-50%);"
        end
      end
    end
  end
end