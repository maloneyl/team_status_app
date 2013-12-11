class StatusesController < ApplicationController

  def new
    @group = Group.find params[:group_id]
    @status = Status.new
  end

  def create
    @group_id = params[:group_id]
    @status = Status.new params[:status]
    @status.group_id = @group_id
    @status.user_id = current_user.id
    @status.save!
    # reminder: need to add logic to prevent more than one 'tracking' status
    redirect_to group_path(@group_id)
  end

  def switch_tracking
    group = Group.find params[:group_id]
    status = Status.find params[:id]
    status.tracking = !status.tracking
    status.save!
    update_duration(status, status.tracking)
  end

  def update_duration(status, tracking)
    status = status
    tracking = tracking
    if status.tracking == false
      status.duration ||= 0 # duration is nil when status is initialized
      if status.previously_updated_at?
        status.duration += (status.updated_at - status.previously_updated_at).to_i # seconds
      else
        status.duration += (status.updated_at - status.created_at).to_i # seconds
      end
      status.previously_updated_at = status.updated_at
    end
    status.save!
    redirect_to group_path(status.group_id)
  end

end
