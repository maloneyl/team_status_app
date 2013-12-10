class Statuses < ActiveRecord::Migration
  def up
    create_table :statuses do |t|
      t.text :body
      t.boolean :tracking
      t.integer :duration # number of seconds
      t.datetime :previously_updated_at
      t.timestamps # :created_at, :modified_at
      t.belongs_to :user
      t.belongs_to :project
    end
  end

  def down
    drop_table :statuses
  end
end
