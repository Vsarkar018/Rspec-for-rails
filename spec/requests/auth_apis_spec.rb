require 'rails_helper'

RSpec.describe "AuthApis", type: :request do
  describe "Post /api/v1/auth/" do
    context "Register user" do
      it "returns the register user" do
        post '/api/v1/auth/signup' ,params: {name: "Test user" , password: "1234" , email: "user@gmail.com"}
        expect(json_response).to have_key('user')
        expect(json_response['user']).to have_key('id')
        expect(json_response['user']['id']).to be_present

        expect(json_response['user']).to have_key('name')
        expect(json_response['user']['name']).to eq("Test user")

        expect(json_response['user']).to have_key('email')
        expect(json_response['user']['email']).to eq("user@gmail.com")

        expect(json_response).to have_key('token')
        expect(json_response['token']).to be_present
      end
      it "returns error for any of the missing parameters" do
        post '/api/v1/auth/signup' ,params: {name: "" , password: "" , email: ""}
        expect(response).to have_http_status(422)
        expect(json_response['error']).to be_present
      end
    end

    context "Login user" do
      it "returns the token with valid parameters" do
        user = FactoryBot.create(:user)
        post '/api/v1/auth/login' , params: {email: user.email, password: '12345'}
        expect(response).to have_http_status(201)
        expect(json_response).to have_key('token')
        expect(json_response['token']).to be_present
      end
      it "returns error with invalid parameters" do
        post '/api/v1/auth/login' , params: {email: '', password: ''}
        expect(response).to have_http_status(401)
        expect(json_response['error']).to be_present
      end
      it "return error with wrong password" do
        user = FactoryBot.create(:user)
        post '/api/v1/auth/login' , params: {email: user.email , password: '342423432'}
        expect(response).to have_http_status(401)
        expect(json_response['error']).to be_present
      end
    end
  end
end
