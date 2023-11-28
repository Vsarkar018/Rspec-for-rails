module V1
  class UserApi < Grape::API
    # use Middleware::AuthMiddleware
    USER_HELPER = Helpers::UserHelper
    AUTH_HELPER = Helpers::AuthHelper

    version 'v1', using: :path
    format :json

    rescue_from USER_HELPER::Error do |e|
      error!({error:e.message},e.status)
    end
    rescue_from AUTH_HELPER::Error do |e|
      error!({error:e.message},e.status)
    end
    resource :user do
      desc 'Get User Data'
      get do
        token = AUTH_HELPER.new.verify_token(headers['Authorization'])
        data = JwtService.decode(token)
        user = USER_HELPER.new.get_user(data[:user][:email])
      end
    end
  end
end
