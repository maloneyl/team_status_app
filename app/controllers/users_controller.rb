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

    # update item duration if still tracking
    # get status.durations._.time_elapsed into status.time_tracked for today's items
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

    # get status.durations._.time_elapsed into status.time_tracked for yesterday's items
    if @items_yesterday.present?
      @items_yesterday.each do |status|
        time = status.durations.yesterday.sum(:time_elapsed)
        status.update_column(:time_tracked, time) # skip after_save and also no updated_at
      end
    end
  end

  protected

  def after_update_path_for(resource) # default devise behavior after account update is to redirect to root_path
    user_path(resource)
  end

end
