# class ActivityObserver < BaseObserver
#   observe :issue, :note, :milestone

#   def after_create(record)
#     event_author_id = record.author_id

#     if record.kind_of?(Note)
#       # Skip system notes, like status changes and cross-references.
#       return true if record.system?

#       # Skip wall notes to prevent spamming of dashboard
#       return true if record.noteable_type.blank?
#     end

#     if event_author_id
#       event = create_event(record, Event.determine_action(record))
      
#       if record.kind_of?(Note) and Event.determine_action(record) == Event::COMMENTED
#         create_event_notification(record, event)
#       end
#     end
#   end

#   def after_close(record, transition)
#     create_event(record, Event::CLOSED)
#   end

#   def after_reopen(record, transition)
#     create_event(record, Event::REOPENED)
#   end

#   protected

#   def create_event(record, status)
#     event = Event.create(
#       project: record.project,
#       target_id: record.id,
#       target_type: record.class.name,
#       action: status,
#       author_id: current_user.id
#     )

#     return event
#   end

  
# end
