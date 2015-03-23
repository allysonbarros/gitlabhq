# EventCreateService class
#
# Used for creating events feed on dashboard after certain user action
#
# Ex.
#   EventCreateService.new.new_issue(issue, current_user)
#
class EventCreateService
  def open_issue(issue, current_user)
    create_record_event(issue, current_user, Event::CREATED)
  end

  def close_issue(issue, current_user)
    create_record_event(issue, current_user, Event::CLOSED)
  end

  def reopen_issue(issue, current_user)
    create_record_event(issue, current_user, Event::REOPENED)
  end

  def open_mr(merge_request, current_user)
    create_record_event(merge_request, current_user, Event::CREATED)
  end

  def close_mr(merge_request, current_user)
    create_record_event(merge_request, current_user, Event::CLOSED)
  end

  def reopen_mr(merge_request, current_user)
    create_record_event(merge_request, current_user, Event::REOPENED)
  end

  def merge_mr(merge_request, current_user)
    create_record_event(merge_request, current_user, Event::MERGED)
  end

  def open_milestone(milestone, current_user)
    create_record_event(milestone, current_user, Event::CREATED)
  end

  def close_milestone(milestone, current_user)
    create_record_event(milestone, current_user, Event::CLOSED)
  end

  def reopen_milestone(milestone, current_user)
    create_record_event(milestone, current_user, Event::REOPENED)
  end

  def leave_note(note, current_user)
    event = create_record_event(note, current_user, Event::COMMENTED)
    create_event_notification(note, event)
  end

  def join_project(project, current_user)
    create_event(project, current_user, Event::JOINED)
  end

  def leave_project(project, current_user)
    create_event(project, current_user, Event::LEFT)
  end

  def create_project(project, current_user)
    create_event(project, current_user, Event::CREATED)
  end

  def push(project, current_user, push_data)
    create_event(project, current_user, Event::PUSHED, data: push_data)
  end

  private

  def create_record_event(record, current_user, status)
    return create_event(record.project, current_user, status, target_id: record.id, target_type: record.class.name)
  end

  def create_event(project, current_user, status, attributes = {})
    attributes.reverse_merge!(
      project: project,
      action: status,
      author_id: current_user.id
    )

    Event.create(attributes)
    create_event_notification_to_observers_and_participating_users(record, current_user, event)
  end

  def create_event_notification_to_observers_and_participating_users(record, current_user, event)
    ns = NotificationService.new
    author = current_user
    project = record.project
    message = ""
    title = ""
    mentioned_users = []

    case event.action
      when Event::CREATED
        title = "opened"
        message = record.title
      when Event::CLOSED
        title = "closed"
        message = record.title
      when Event::REOPENED
        title = "reopened"
        message = record.title
      when Event::COMMENTED
        title = "commented on"
        message = record.note
        mentioned_users = record.mentioned_users
      when Event::MERGED
        title = "accepted"
        message = record.title
    end
    
    if event.target.respond_to?(:participants)
      recipients = event.target.participants
    else
      recipients = event.target.noteable.participants
    end

    # Deletando o autor e os usuários mencionados no comentário.
    recipients.delete(author)
    mentioned_users.each do |mentioned_user|
      recipients.delete(mentioned_user)      
    end

    recipients.each do |recipient|
      EventNotification.create!({
        user: recipient,
        author: author,
        project: project,
        title: title,
        message: message,
        event: event,
        read: false
      })
    end

    return event
  end

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

    return event
  end
end
