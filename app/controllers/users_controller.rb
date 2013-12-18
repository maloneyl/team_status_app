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
    @groups.each do |group|
      group.statuses.with_mentions.each do |status|
        @mentions << status if status.at_user == current_user.username || status.at_user == "all"
      end
    end
    @mentions = @mentions.sort_by(&:created_at).reverse

    # get agendas
    @agendas = @user.agendas.all(:order => 'updated_at DESC')

    # get items for reports
    @items_today = @user.statuses.trackable.today rescue nil
    @items_yesterday = @user.statuses.trackable.yesterday rescue nil

    # update item duration if tracking
    if @items_today.present?
      @items_today.each do |status|
        if status.tracking?
          if status.durations.last.present?
            status.time_tracked = status.durations.today.sum(:time_elapsed) + (Time.now - status.durations.today.last.updated_at).to_i
          else
            status.time_tracked = (Time.now - status.durations.today.last.updated_at).to_i
          end
          status.save!
        end
      end
    end

    if @items_yesterday.present?
      @items_yesterday.each do |status|
        status.time_tracked = status.durations.yesterday.sum(:time_elapsed)
      end
    end
  end

  def update
    super
    @user.save!
  end

end
