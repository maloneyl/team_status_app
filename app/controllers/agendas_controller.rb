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
    respond_to do |format|
      if @agenda.update_attributes(params[:agenda])
        format.html { redirect_to(@agenda.group, :notice => 'Agenda was successfully updated.') }
        format.json { respond_with_bip(@agenda.group) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@agenda.group) }
      end
    end
  end

end
