require 'json'

class GroupsController < ApplicationController

  def new
    @group = Group.new
    @possible_users_to_add = User.all(:conditions => ["id != ?", current_user.id])
  end

  def create
    @group = Group.new params[:group]
    @group.owner_id = current_user.id
    @group.users << current_user
    @group.users << User.find(params[:person]) if params[:person].present?

    if @group.save
      redirect_to @group
    else
      @possible_users_to_add = User.all(:conditions => ["id != ?", current_user.id]) # need to redo this; 'nil' otherwise
      render :new # just rendering view
    end
  end

  def edit
    @group = Group.find params[:id]
    @is_owner = true if @group.owner_id == current_user.id rescue nil
    @existing_member_ids = @group.users.map { |hash| hash[:id ] }
    @possible_users_to_add = User.all(:conditions => ["id not in (?)", @existing_member_ids])
  end

  def update
    @group = Group.find params[:id]
    @group.users << User.find(params[:person]) if params[:person].present?
    if @group.update_attributes params[:group]
      redirect_to @group
    else
      render :edit
    end
  end

  def show
    @group = Group.find params[:id]

    @members = @group.users
    @owner = User.find @group.owner_id
    @is_owner = true if @group.owner_id == current_user.id rescue nil
    @is_member = true if @group.users.where(:id => current_user.id).present? rescue nil

    @agenda = current_user.agendas.where(:group_id => @group.id).first_or_create if @group.users.include?(current_user)
    @agendas = @group.agendas.all(:order => 'user_id, updated_at DESC')

    page = params[:page] || 1
    per_page = 10
    # @statuses = @group.statuses.all(:order => 'created_at DESC')
    @statuses = @group.statuses.paginate(:page => page, :per_page => per_page).all(:order => 'created_at DESC')
  end

  # def get_statuses
  #   group = Group.find params[:group_id]
  #   @statuses = group.statuses.all(:order => 'created_at DESC') # @group.statuses.sort_by(&:created_at).reverse
  #   render :partial => '/groups/statuses'
  # end

  # def day_archive
  #   @day = "something" # need to figure out how to get the day
  #   @statuses = @group.statuses.where("created_at >= ?", @day.beginning_of_day)
  # end

  def remove_member
    member = User.find params[:user_id]
    group = Group.find params[:group_id] # not :id. see routes
    member.agendas.where(:group_id => group.id).delete_all # remove associated agenda
    group.users.delete(member)

    output = {'status' => 'ok'}.to_json
    render json: output
  end
end
