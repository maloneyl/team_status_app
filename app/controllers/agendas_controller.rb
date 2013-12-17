class AgendasController < ApplicationController

  def create
    @group_id = params[:group_id]
    @agenda = Agenda.new params[:agenda]
    @agenda.group_id = @group_id
    @agenda.user_id = current_user.id
    @agenda.save!
    redirect_to group_path(@group_id)
  end

  def update
    @agenda = Agenda.find params[:id]

    if @agenda.update_attributes params[:agenda]
      render json: {status: :ok}.to_json
    else
      render json: {status: :error}.to_json
    end
  end

end
