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
      Status.with_mentions.each do |status|
        @mentions << status if status.at_user == current_user.username || status.at_user == "all"
      end
      @mentions = @mentions.sort_by(&:created_at).reverse

      @agendas = current_user.agendas # .today

      # update duration
      @user.statuses.trackable.today.each do |status|
        if status.tracking?
          if status.duration.present?
            status.duration += (Time.now - status.previously_updated_at).to_i
          else
            status.duration = (Time.now - status.created_at).to_i
          end
          status.save!
          status.previously_updated_at = status.updated_at
          status.save!
        end
      end
    end
  end

  def update
    super
    @user.save!
  end

end
