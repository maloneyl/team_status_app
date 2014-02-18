require 'rails_autolink'

class UsersController < Devise::RegistrationsController

  def create
    super
    @user.role = "member"
    @user.save!
  end

  def show
    @user = User.find params[:id]

    # get groups and mentions
    @mentions = []
    @groups = @user.groups
    @groups.each do |group| # this makes sure mentions from user's old groups are excluded
      group.statuses.with_mentions.each do |status|
        if User.exists?(:id => status.user_id) && status.user != current_user
          @mentions << status if status.at_user == current_user.username || status.at_user == "all"
        end
      end
    end
    @mentions = @mentions.sort_by(&:created_at).reverse

    # get agendas (excluding initial empty ones)
    @agendas = @user.agendas.where("body IS NOT NULL").all(:order => 'updated_at DESC')

    # get items for reports
    @trackable_items_today = @user.statuses.trackable.today rescue nil
    @trackable_items_yesterday = @user.statuses.trackable.yesterday rescue nil

    # get status.durations.yesterday.time_elapsed into status.time_tracked for yesterday's items
    # update item duration if still tracking
    if @trackable_items_yesterday.present?
      @trackable_items_yesterday.each do |status|
        if status.tracking?
          # calculate yesterday's portion
          time_yesterday = status.durations.yesterday.sum(:time_elapsed) + (Time.now.midnight - status.durations.yesterday.last.updated_at).to_i
          status.update_column(:time_tracked, time_yesterday) # update_column: skip after_save (but there's no updated_at change)
          status.update_column(:tracking, false)
          status.durations.last.update_column(:time_elapsed, time_yesterday)

          # move remainder portion to today
          time_today = (Time.now - Time.now.midnight).to_i
          status_carried_forward = status.dup # create new status with same body, tracking, tracked, time_tracked, user_id, group_id
          status_carried_forward.time_tracked = time_today
          status_carried_forward.tracking = true
          status_carried_forward.save! # will then have status id, created_at, updated_at and trigger associated duration entry
          status_carried_forward.update_column(:created_at, status_carried_forward.created_at.midnight + 1.second) # this is so the duplicate status shows up at a reasonable place on the group timeline; plus 1.second for it to not count towards yesterday's end_of_day
          status_carried_forward.update_column(:updated_at, status_carried_forward.created_at)
          status_carried_forward.durations.last.update_column(:time_elapsed, time_today) # fix its durations.last too because we'll be adding up durations in the future
        else
          time = status.durations.yesterday.sum(:time_elapsed)
          status.update_column(:time_tracked, time) # skip after_save and also no updated_at
        end
      end
    end

    # update item duration if still tracking
    # get status.durations.today.time_elapsed into status.time_tracked for today's items
    if @trackable_items_today.present?
      @trackable_items_today.each do |status|
        if status.tracking?
          time = status.durations.today.sum(:time_elapsed) + (Time.now - status.durations.today.last.updated_at).to_i
        else
          time = status.durations.today.sum(:time_elapsed)
        end
        status.update_column(:time_tracked, time) # skip after_save and also no updated_at
      end
    end
  end

  protected

  def after_update_path_for(resource) # default devise behavior after account update is to redirect to root_path
    user_path(resource)
  end

end
