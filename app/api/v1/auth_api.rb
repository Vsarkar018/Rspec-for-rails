module V1
  class AuthApi < Grape::API
    AUTH_HELPER = Helpers::AuthHelper
    version 'v1' , using: :path
    format :json
    rescue_from AUTH_HELPER::Error do |e|
      error!({error:e.message},e.status)
    end

    resource :auth do
      desc 'Register User'

      params do
        requires :name, type: String, desc: "Name of the user"
        requires :email, type: String, desc: "Email of the user"
        requires :password, type: String, desc: "Password of the user"
      end

      post :signup do
        user = AUTH_HELPER.new.signup_user(params)
        # puts "#{user.name}, #{user.email}"
          token = JwtService.generate_token({user: {user_id:user.id,name:user.name,email:user.email}})
          {user: user , token: token}
      end

      desc "Login User"
      params do
        requires :email, type: String, desc: "Email of the user"
        requires :password, type: String, desc: "Password of the user"
      end
      post :login do
        user = AUTH_HELPER.new.login_user(params)
        token = JwtService.generate_token({user: {user_id:user.id,name:user.name,email:params[:email]}})
        {token:token}
      end
    end
  end
end
