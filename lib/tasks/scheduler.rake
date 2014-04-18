namespace :scheduler do

  desc "This task is called by the Heroku scheduler add-on every midnight UTC to handle statuses with time-tracking still on"
  task :update_tracking_statuses => :environment do
    statuses = Status.where(:tracking => true).all
    if statuses.any?
      statuses.each do |status|
        calculate_first_portion(status)
        move_remaining_portion_to_current_day(status)
      end
    end
  end

  def calculate_first_portion(status)
    time_yesterday = status.durations.yesterday.sum(:time_elapsed) + (Time.now.midnight - status.durations.yesterday.last.updated_at).to_i
    status.update_column(:time_tracked, time_yesterday) # update_column: skip after_save (but there's no updated_at change)
    status.update_column(:tracking, false)
    status.durations.last.update_column(:time_elapsed, time_yesterday)
  end

  def move_remaining_portion_to_current_day(status)
    time_today = (Time.now - Time.now.midnight).to_i
    status_carried_forward = status.dup # create new status with same body, tracking, tracked, time_tracked, user_id, group_id
    status_carried_forward.body = "[b/f] #{status_carried_forward.body}" unless status_carried_forward.body.start_with?("[b/f]")
    status_carried_forward.time_tracked = time_today
    status_carried_forward.tracking = true
    status_carried_forward.save! # will then have status id, created_at, updated_at and trigger associated duration entry
    status_carried_forward.update_column(:created_at, status_carried_forward.created_at.midnight + 1.second)
    status_carried_forward.update_column(:updated_at, status_carried_forward.created_at)
    status_carried_forward.durations.last.update_column(:time_elapsed, time_today) # fix its durations.last too because we'll be adding up durations in the future
  end
end
