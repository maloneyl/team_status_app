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
    @is_member = true if @members.where(:id => current_user.id).present? rescue nil

    @members.each do |member|
      @agendas << member.agendas.where(:group_id => @group.id).first_or_create
    end

    page = params[:page] || 1
    per_page = 10
    @statuses = @group.statuses.paginate(:page => page, :per_page => per_page).all(:order => 'created_at DESC')
  end

  def remove_member
    member = User.find params[:user_id]
    group = Group.find params[:group_id] # not :id (see routes)
    member.agendas.where(:group_id => group.id).delete_all # remove associated agenda
    group.users.delete(member)

    output = {'status' => 'ok'}.to_json
    render json: output
  end

  def destroy
    group = Group.find params[:id]
    group.destroy
    redirect_to user_path(current_user)
  end

end
