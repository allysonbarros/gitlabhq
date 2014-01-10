class EventNotificationsController < ApplicationController
	def inbox
		@event_notifications = current_user.event_notifications
	end

	def sent
		@event_notifications = current_user.event_notifications_sent
	end

	def show
		@event_notification = EventNotification.find(params[:id])

		render :text => @event_notification.title
	end
end
