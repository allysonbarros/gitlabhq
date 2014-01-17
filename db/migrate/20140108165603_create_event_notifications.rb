class CreateEventNotifications < ActiveRecord::Migration
  def change
    create_table :event_notifications do |t|
      t.text :title, :null => false
      t.text :message, :null => false
      t.boolean :read
      t.integer :user_id, :null => false
      t.integer :author_id, :null => false
      t.integer :project_id
      t.integer :event_id
      
      t.timestamps
    end
  end
end
