# EventCreateService class
#
# Used for creating events feed on dashboard after certain user action
#
# Ex.
#   EventCreateService.new.new_issue(issue, current_user)
#
class EventCreateService
  def open_issue(issue, current_user)
    create_event(issue, current_user, Event::CREATED)
  end

  def close_issue(issue, current_user)
    create_event(issue, current_user, Event::CLOSED)
  end

  def reopen_issue(issue, current_user)
    create_event(issue, current_user, Event::REOPENED)
  end

  def open_mr(merge_request, current_user)
    create_event(merge_request, current_user, Event::CREATED)
  end

  def close_mr(merge_request, current_user)
    create_event(merge_request, current_user, Event::CLOSED)
  end

  def reopen_mr(merge_request, current_user)
    create_event(merge_request, current_user, Event::REOPENED)
  end

  def merge_mr(merge_request, current_user)
    create_event(merge_request, current_user, Event::MERGED)
  end

  def open_milestone(milestone, current_user)
    create_event(milestone, current_user, Event::CREATED)
  end

  def close_milestone(milestone, current_user)
    create_event(milestone, current_user, Event::CLOSED)
  end

  def reopen_milestone(milestone, current_user)
    create_event(milestone, current_user, Event::REOPENED)
  end

  def leave_note(note, current_user)
    event = create_event(note, current_user, Event::COMMENTED)
    create_event_notification(note, event)
  end

  private

  def create_event(record, current_user, status)
    event = Event.create(
      project: record.project,
      target_id: record.id,
      target_type: record.class.name,
      action: status,
      author_id: current_user.id
    )

    return event
  end

  # Method used to create a new EventNotification record based on Note created instance.
  def create_event_notification(record, event)
    author = record.author
    project = record.project
    message = record.note
    mentioned_users = record.mentioned_users

    mentioned_users.each do |user|
      EventNotification.create({
        user: user,
        author: author,
        project: project,
        title: "mentioned you",
        message: message,
        event: event,
        read: false
      })
    end
  end
end
