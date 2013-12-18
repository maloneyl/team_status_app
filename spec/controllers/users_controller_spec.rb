require 'spec_helper'

describe UsersController do
  # it 'should pass' do
  #   true
  # end

  describe 'GET show' do
    let!(:user) { FactoryGirl.create :user }

    it 'should assign @user' do
      get :show, {:id => user.id} # the id hash represents params that we'd have in the real thing
      expect(assigns[:user]).to eq(user)
    end

    it 'should render the show template' do
      get :show, {:id => user.id}
      expect(response).to render_template('show') # render_template is a helper
    end
  end

end
