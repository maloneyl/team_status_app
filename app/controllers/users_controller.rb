class UsersController < Devise::RegistrationsController

  def create
    super
    # @user.first_name = params[:user][:first_name]
    # @user.last_name = params[:user][:last_name]
    # @user.username = params[:user][:username]
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
    end
  end

  def update
    super
    # @user.first_name = params[:user][:first_name]
    # @user.last_name = params[:user][:last_name]
    # @user.username = params[:user][:username]
    # @user.image = params[:user][:image]
    @user.save!
  end

end
