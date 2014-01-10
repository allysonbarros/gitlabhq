class EventNotificationsController < ApplicationController
	def inbox
		@event_notifications = current_user.event_notifications.page(params[:page]).per(20)

		@event_notifications = case params[:scope]
                  when 'read' then
                    @event_notifications.read.page(params[:page]).per(20)
                  when 'unread' then
                    @event_notifications.unread.page(params[:page]).per(20)
                  else
                    @event_notifications.page(params[:page]).per(20)
                  end
	end

	def sent
		@event_notifications_sent = current_user.event_notifications_sent.page(params[:page]).per(20)
	end

	def show
		@event_notification = EventNotification.find(params[:id])

		render :text => @event_notification.title
	end
end
