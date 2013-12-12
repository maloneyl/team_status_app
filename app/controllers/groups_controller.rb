class GroupsController < ApplicationController

  def show
    @group = Group.find params[:id]
    @members = @group.users
    @owner = User.find @group.owner_id
    @is_owner = true if @group.owner_id == current_user.id rescue nil
    @is_member = true if @group.users.where(:id => current_user.id).present? rescue nil
    @agendas = @group.agendas.all(:order => 'user_id, created_at DESC')
    @statuses = @group.statuses.all(:order => 'created_at DESC') # @group.statuses.sort_by(&:created_at).reverse
  end

  def day_archive
    @day = "something" # need to figure out how to get the day
    @statuses = @group.statuses.where("created_at >= ?", @day.beginning_of_day)
  end

end
