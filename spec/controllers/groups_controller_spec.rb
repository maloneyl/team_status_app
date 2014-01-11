require 'spec_helper'

describe GroupsController do

  describe 'GET show' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
      @group = FactoryGirl.create(:group)
      @group.owner_id = @user.id
      @group.users << @user
      @group.save
    end

    it 'should assign @group' do
      get :show, {:id => @group.id}
      expect(assigns[:group]).to eq(@group)
    end

    it 'should render the show template' do
      get :show, {:id => @group.id}
      expect(response).to render_template('show')
    end
  end

end
