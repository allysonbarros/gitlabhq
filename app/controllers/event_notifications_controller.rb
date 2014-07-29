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

		if @event_notification.event.issue?
	      redirect_to project_issue_url(@event_notification.event.project, @event_notification.event.issue)
	    elsif @event_notification.event.merge_request?
	      redirect_to project_merge_request_url(@event_notification.event.project, @event_notification.event.merge_request)
	    elsif event.note?
			if @event_notification.event.note_target
		      if @event_notification.event.note_commit?
		        redirect_to project_commit_path(@event_notification.event.project, @event_notification.event.note_commit_id)
		      elsif @event_notification.event.note_project_snippet?
		        redirect_to project_snippet_path(@event_notification.event.project, @event_notification.event.note_target)
		      else
		        if @event_notification.event.note? && @event_notification.event.note_commit?
			      redirect_to project_commit_path(@event_notification.event.project, @event_notification.event.note_target)
			    else
			      redirect_to polymorphic_path([@event_notification.event.project, @event_notification.event.note_target])
			    end
		      end
		    end
	    elsif @event_notification.event.wall_note?
	      redirect_to project_wall_path(@event_notification.event.project)
	    else
	      redirect_to projects_dashboard_path
	    end
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

	def mark_all_as_read
		@event_notifications = current_user.event_notifications.unread
		@event_notifications.each do |en|
			en.read = true
			en.save
		end

		redirect_to :inbox_user_notifications
	end
end
