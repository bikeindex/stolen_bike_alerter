require "spec_helper"
describe WelcomeController do
  describe "root index" do
    context "no user" do
      before do
        get :index
      end
      it { should respond_with(:success) }
      it { should render_template(:index) }
      it { should_not set_the_flash }
    end
    context "with user" do
      before do
        @user = user_from_twitter_fixture
        sign_in @user
        get :index
      end
      it { should redirect_to(twitter_account_url(@user.screen_name)) }
      it { should_not set_the_flash }
    end
  end
end
