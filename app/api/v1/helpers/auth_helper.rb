module V1
  module Helpers
    class AuthHelper
      class Error < StandardError
        attr_reader :status

        def initialize(message,status)
          super(message)
          @status = status
        end
      end

      def signup_user(params)
        user = User.new(name: params[:name],email: params[:email] , password: params[:password])
        if user.save!
          user
        else
          raise Error.new("Something went wrong",500)
        end
      end

        def login_user(params)
          user = User.find_by(email: params[:email])
          if user  && user.authenticate(params[:password])
            user
          elsif !user
            raise Error.new("Account doesn't exist",401)
          else
            raise Error.new("Invalid Credentials",401)
          end
        end


        def verify_token(auth_header)
          unless auth_header && auth_header.starts_with?("Bearer ")
            raise Error.new("Authorization failed",401)
          end
          token = auth_header.split(" ")[1]
          if token.nil? || token.empty? || token == "null"
            raise Error.new("Authorization failed",401)
          end
          token
        end
    end
  end
end
