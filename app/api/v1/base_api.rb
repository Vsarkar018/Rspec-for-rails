module V1
  class BaseApi < Grape::API
    prefix 'api'
    mount V1::AuthApi
    mount V1::TaskApi
    mount V1::UserApi
  end
end
