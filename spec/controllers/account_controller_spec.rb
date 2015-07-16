require 'spec_helper'
describe AccountController do

  describe 'root index' do 
    context "with user" do 
      before do 
        user = user_from_twitter_fixture
        sign_in user
        get :index
      end
      it { should respond_with(:success) }
      it { should render_template(:index) }
      it { should_not set_the_flash }
    end
    context "no user" do 
      before do
        get :index
      end
      it { should redirect_to(user_omniauth_authorize_path(:twitter)) }
      it { should_not set_the_flash }
    end
  end  

end
