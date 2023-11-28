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
        User.find_by!(email: email)
      rescue => error
        raise error
      end
    end
  end
end
