# == Schema Information
#
# Table name: EventNotifications
#
#  id            :integer          not null, primary key
#  message       :title            not null
#  message       :text             not null
#  read          :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#  author_id     :integer          not null
#  project_id    :integer
#  event_id      :integer
#

class EventNotification < ActiveRecord::Base
	attr_accessible :title, :message, :read, :project, :project_id, :author, :author_id, :event, :event_id

    belongs_to :user, class_name: "User"
    belongs_to :author, class_name: "User"
	belongs_to :project
	belongs_to :event

    delegate :name, :email, to: :author, prefix: true, allow_nil: true
    delegate :name, :email, to: :user, prefix: true, allow_nil: true

    validates :title, :message, presence: true
    validates :author, presence: true

    scope :unread, -> { where.not(read: true) }
    scope :read, -> { unscoped.where(read: true) }

	def project_name
        if project
          project.name_with_namespace
        else
          "(deleted project)"
        end
	end
end
