class Agendas < ActiveRecord::Migration
  def change
    create_table :agendas do |t|
      t.string :body
      t.timestamps
      t.belongs_to :group
      t.belongs_to :user
    end

  add_index :agendas, :group_id
  add_index :agendas, :user_id
  end
end
