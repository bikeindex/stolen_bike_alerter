require 'spec_helper'
describe TwitterAccountsController do

  describe 'root index' do 
    context "with user" do 
      before do 
        user = user_from_twitter_fixture
        sign_in user
        get :show, id: "adsfasdfasdf"
      end
      it { should respond_with(:success) }
      it { should render_template(:show) }
      it { should_not set_the_flash }
    end
    context "no user" do 
      before do
        get :show, id: "adsfasdfasdf"
      end
      it { should redirect_to(user_omniauth_authorize_path(:twitter)) }
      it { should_not set_the_flash }
    end
  end  

  describe 'update' do 
    it "should update" do 
      user = user_from_twitter_fixture
      user.update_twitter_info(user.twitter_info)
      sign_in user
      opts = {
        append_block: "Cool stuff",
        address: "new address",
        is_active: true,
      }
      put :update, id: 'something', twitter_account: opts
      user.twitter_account.reload
      expect(user.twitter_account.append_block).to eq('Cool stuff')
      expect(user.twitter_account.is_active).to eq(true)
      expect(user.twitter_account.address).to eq('new address')
    end
  end

end
