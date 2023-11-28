require 'rails_helper'

RSpec.describe "UserApis", type: :request do
  describe "GET /api/v1/user" do
    context "when authorized" do
      before :each do
        @user = FactoryBot.create(:user)
        @headers = {'Authorization' => "Bearer #{JwtService.generate_token({user:{user_id:@user.id,email:@user.email,name:@user.name}})}"}
      end
      it "returns the user data" do
        get '/api/v1/user', headers: @headers
        expect(response).to have_http_status(200)
        expect(json_response['email']).to eq(@user.email)
      end
    end
    context "when not authorized" do
      it "returns 401" do
        get '/api/v1/user' do
          expect(response).to have_http_status(401)
          expect(json_response["message"]).to eq("Authorization failed")
        end
      end
    end
  end
end
