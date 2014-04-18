require 'rails_autolink'

class UsersController < Devise::RegistrationsController

  def create
    super
    @user.role = "member"
    @user.save!
  end

  def show
    @user = User.find params[:id]
    @groups = @user.groups rescue nil
    get_mentions
    get_agendas
    get_reports
  end

  protected

  def get_mentions
    @mentions = []
    @groups.each do |group|
      group.statuses.with_mentions.each do |status|
        if User.exists?(:id => status.user_id) && status.user != current_user
          @mentions << status if status.at_user == current_user.username || status.at_user == "all"
        end
      end
    end
    @mentions = @mentions.sort_by(&:created_at).reverse
  end

  def get_agendas
    @agendas = @user.agendas.where("body IS NOT NULL").all(:order => 'updated_at DESC')
  end

  def get_reports
    @trackable_items_today = @user.statuses.trackable.today rescue nil
    @trackable_items_yesterday = @user.statuses.trackable.yesterday rescue nil
    calculate_time_tracked_yesterday if @trackable_items_yesterday.present?
    calculate_time_tracked_today if @trackable_items_today.present?
  end

  def calculate_time_tracked_yesterday
    @trackable_items_yesterday.each do |status|
      time = status.durations.yesterday.sum(:time_elapsed)
    end
  end

  # update item duration if still tracking
  # get status.durations.today.time_elapsed into status.time_tracked for today's items
  def calculate_time_tracked_today
    @trackable_items_today.each do |status|
      if status.tracking?
        time = status.durations.today.sum(:time_elapsed) + (Time.now - status.durations.today.last.updated_at).to_i
      else
        time = status.durations.today.sum(:time_elapsed)
      end
      status.update_column(:time_tracked, time) # skip after_save and also no updated_at
    end
  end

  # override default devise behavior of redirecting to root_path after account update
  def after_update_path_for(resource)
    user_path(resource)
  end

end
