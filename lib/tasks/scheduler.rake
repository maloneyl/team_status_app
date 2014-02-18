namespace :scheduler do

  desc "This task is called by the Heroku scheduler add-on"
  task :update_tracking_statuses => :environment do
    statuses = Status.where(:tracking => true)
    statuses.each do |status|
      # first portion
      time_yesterday = status.durations.yesterday.sum(:time_elapsed) + (Time.now.midnight - status.durations.yesterday.last.updated_at).to_i
      status.update_column(:time_tracked, time_yesterday) # update_column: skip after_save (but there's no updated_at change)
      status.update_column(:tracking, false)
      status.durations.last.update_column(:time_elapsed, time_yesterday)

      # move remainder portion to current day
      time_today = (Time.now - Time.now.midnight).to_i
      status_carried_forward = status.dup # create new status with same body, tracking, tracked, time_tracked, user_id, group_id
      status_carried_forward.body = "[FROM PREVIOUS DAY] #{status_carried_forward.body}"
      status_carried_forward.time_tracked = time_today
      status_carried_forward.tracking = true
      status_carried_forward.save! # will then have status id, created_at, updated_at and trigger associated duration entry
      status_carried_forward.update_column(:created_at, status_carried_forward.created_at.midnight + 1.second) # this is so the duplicate status shows up at a reasonable place on the group timeline; plus 1.second for it to not count towards yesterday's end_of_day
      status_carried_forward.update_column(:updated_at, status_carried_forward.created_at)
      status_carried_forward.durations.last.update_column(:time_elapsed, time_today) # fix its durations.last too because we'll be adding up durations in the future
    end
  end
end
