require 'spec_helper'
describe TwitterAccountsController do

  describe 'show' do
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
    context "with user" do 
      before do 
        user = user_from_twitter_fixture
        user.is_admin = true
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
      it { should redirect_to(omniauth_authorize_path("user", :twitter)) }
      it { should_not set_the_flash }
    end
  end  

  describe 'update' do 
    it "should update" do 
      user = FactoryGirl.create(:user_with_active_twitter_account)
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
    it "should update arbitrary account with admin" do 
      twitter_account = FactoryGirl.create(:secondary_active_twitter_account)
      user = FactoryGirl.create(:user_with_active_twitter_account, is_admin: true)
      sign_in user
      opts = {
        append_block: "other awesome stuff stuff",
        address: "settled address",
        is_active: true,
        screen_name: twitter_account.screen_name,
      }
      put :update, id: 'asdddd', twitter_account: opts
      twitter_account.reload
      expect(twitter_account.append_block).to eq('other awesome stuff stuff')
      expect(twitter_account.is_active).to eq(true)
      expect(twitter_account.address).to eq('settled address')
      user.twitter_account.reload
      expect(user.twitter_account.append_block).to_not eq('other awesome stuff stuff')
    end
  end


  describe 'index' do 
    context "with user" do 
      before do 
        twitter_account = FactoryGirl.create(:secondary_active_twitter_account)
        admin = FactoryGirl.create(:user_with_active_twitter_account, is_admin: true)
        sign_in admin
        get :index
      end
      it { should respond_with(:success) }
      it { should render_template(:index) }
      it { should_not set_the_flash }
    end
    context "with non-admin user" do 
      before do 
        @user = FactoryGirl.create(:user_with_active_twitter_account)
        sign_in @user
        get :index
      end
      it { should redirect_to(twitter_account_path(id: @user.screen_name)) }
      it { should_not set_the_flash }
    end
    context "no user" do 
      before do
        get :index
      end
      it { should redirect_to(omniauth_authorize_path("user", :twitter)) }
      it { should_not set_the_flash }
    end
  end  



end
