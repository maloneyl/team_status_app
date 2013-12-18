require 'spec_helper'

describe UsersController do
  # it 'should pass' do
  #   true
  # end

  describe 'GET show' do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it 'should assign @user' do
      get :show, {:id => @user.id}
      expect(assigns[:user]).to eq(@user)
    end

    it 'should render the show template' do
      get :show, {:id => @user.id}
      expect(response).to render_template('show')
    end
  end

end
