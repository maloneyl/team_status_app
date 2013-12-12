class GroupsController < ApplicationController

  def show
    @group = Group.find params[:id]
    @group_members = @group.users
    @is_owner = true if @group.owner_id == current_user.id
    @is_member = true if @group.users.where(:id => current_user.id).present?
    @agendas = @group.agendas.all(:order => 'user_id, created_at DESC')
    @statuses = @group.statuses.all(:order => 'created_at DESC') # @group.statuses.sort_by(&:created_at).reverse
  end

end
