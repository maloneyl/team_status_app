class RenameDurationToTimeTracked < ActiveRecord::Migration
  def change
    rename_column :statuses, :duration, :time_tracked
  end
end
