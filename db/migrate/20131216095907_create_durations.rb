class CreateDurations < ActiveRecord::Migration
  def change
    create_table :durations do |t|
      t.belongs_to :status
      t.integer :time_elapsed
      t.timestamps
    end
  add_index :durations, :status_id
  end
end
