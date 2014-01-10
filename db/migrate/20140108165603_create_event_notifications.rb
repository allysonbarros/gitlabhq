class CreateEventNotifications < ActiveRecord::Migration
  def change
    create_table :event_notifications do |t|
      t.text :title
      t.text :message
      t.boolean :read
      t.integer :user_id, :null => false
      t.integer :author_id, :null => false
      t.integer :project_id, :null => false
      t.integer :event_id, :null => false
      
      t.timestamps
    end
  end
end
