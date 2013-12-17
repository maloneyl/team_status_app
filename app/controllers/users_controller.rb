class UsersController < Devise::RegistrationsController

  def create
    super
    @user.role = "member"
    @user.save!
  end

  def show
    @user = User.find params[:id]

    if user_signed_in?
      @mentions = []
      @groups = @user.groups
      @groups.each do |group|
        group.statuses.with_mentions.each do |status|
          @mentions << status if status.at_user == current_user.username || status.at_user == "all"
        end
      end
      @mentions = @mentions.sort_by(&:created_at).reverse

      @agendas = current_user.agendas

      # update duration if tracking
      @user.statuses.trackable.today.each do |status|
        if status.tracking?
          if status.durations.last.present?
            status.time_tracked = status.durations.today.sum(:time_elapsed) + (Time.now - status.durations.today.last.updated_at).to_i
          else
            status.time_tracked = (Time.now - status.durations.today.last.updated_at).to_i
          end
          status.save!
        end
      end

      @user.statuses.trackable.yesterday.each do |status|
        status.time_tracked = status.durations.yesterday.sum(:time_elapsed)
      end
    end
  end

  def update
    super
    @user.save!
  end

end
