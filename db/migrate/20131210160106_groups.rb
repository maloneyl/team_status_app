class Groups < ActiveRecord::Migration
  def up
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id
      t.timestamps
    end
  end

  def down
    drop_table :groups
  end
end
