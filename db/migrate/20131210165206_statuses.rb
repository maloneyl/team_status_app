class Statuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.text :body
      t.boolean :tracking
      t.boolean :tracked
      t.integer :time_tracked # number of seconds
      t.timestamps # :created_at, :modified_at
      t.belongs_to :user
      t.belongs_to :group
    end

    add_index :statuses, :user_id
    add_index :statuses, :group_id
  end
end
