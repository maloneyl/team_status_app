class AgendasController < ApplicationController

  def create
    @group_id = params[:group_id]
    @agenda = Agenda.new params[:agenda]
    @agenda.group_id = @group_id
    @agenda.user_id = current_user.id
    @agenda.save!
    redirect_to group_path(@group_id)
  end

end
