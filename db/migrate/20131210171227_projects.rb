class Projects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.timestamps
      t.belongs_to :group
    end
  end
end
