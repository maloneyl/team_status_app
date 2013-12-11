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
    @mentions = []
    Status.with_mention.each do |status|
      @mentions << status if status.at_user == @user.username
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
