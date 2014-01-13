class EventNotificationsController < ApplicationController
	def inbox
		@event_notifications = current_user.event_notifications.page(params[:page]).per(20)

		@event_notifications = case params[:scope]
                  when 'read' then
                    @event_notifications.read.page(params[:page]).per(20)
                  when 'unread' then
                    @event_notifications.unread.page(params[:page]).per(20)
                  else
                    @event_notifications
                  end
	end

	def sent
		@event_notifications_sent = current_user.event_notifications_sent.none.page(params[:page]).per(20)
	end

	def show
		@event_notification = EventNotification.find(params[:id])
		@event_notification.read = true
		@event_notification.save!
	end

	def destroy
		@event_notification = EventNotification.find(params[:id])
		@event_notification.destroy

    	redirect_to :inbox_user_notifications, notice: 'Notification was deleted.'
	end

	def mark_as_unread
		@event_notification = EventNotification.find(params[:id])
		@event_notification.read = false
		@event_notification.save!

		redirect_to :inbox_user_notifications
	end
end
