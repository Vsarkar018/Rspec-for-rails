require 'rails_helper'

RSpec.describe "TaskApis", type: :request do
  describe "GET /api/v1/tasks" do
    context "when authorized" do
      before :each do
        @user = FactoryBot.create(:user)
        @task = FactoryBot.create(:task)
      end
    end
  end
end
