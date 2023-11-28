module V1
  module Helpers
    class UserHelper
      class Error < StandardError
        attr_reader :status
        def initialize(message,status)
          super(message)
          @status = status
        end
      end
      def get_user(email)
        user = User.find_by!(email: email)
        if user
          user
        else
          raise Error.new("Unable to fetch user",500)
        end
      end
    end
  end
end
