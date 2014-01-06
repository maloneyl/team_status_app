require 'json'

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
    @status.tracked = @status.tracking

    if @status.save
      if @status.tracking # avoid double-counting: stop any running timer
        statuses_to_update = current_user.statuses.where(:tracking => true).all
          if statuses_to_update.any?
            statuses_to_update.each do |s|
              s.tracking = false if s != @status
              s.save!
            end
          end
      end
      redirect_to group_path(@group_id)
      # render json: {
      #   status: :ok,
      #   creator: @status.user.full_name
      # }.to_json
    else
      redirect_to group_path(@group_id), :alert => "Status cannot be empty!"
      # render json: {status: :error}.to_json
    end

  end

  def destroy
    status = Status.find params[:id]
    status.destroy
    # redirect_to group_path(params[:group_id])

    output = {'status' => 'ok'}.to_json
    render json: output
  end

  def switch_tracking
    group = Group.find params[:group_id]
    status = Status.find params[:id]
    status.tracking = !status.tracking
    # redirect_to group_path(status.group_id)
    if status.save!
      output = {'status' => 'ok'}.to_json
      render json: output
    end
  end


end
