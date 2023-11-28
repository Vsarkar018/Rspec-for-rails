require 'rails_helper'

RSpec.describe "TaskApis", type: :request do
  describe " /api/v1/tasks" do
    context "When authorized" do
      before :all do
        @task = FactoryBot.create(:task, :pending)
        @headers = {'Authorization' => "Bearer #{JwtService.generate_token({user:{user_id:@task.user_id}})}"}
      end
      context "Create Task" do
        it "with valid parameters" do
          post '/api/v1/tasks' , params: {tasks: @task.tasks, status: @task.status} , headers: @headers
          expect(response).to have_http_status(201)
          expected_attr =  JSON.parse(@task.to_json).except('id','created_at','updated_at')
          actual_attr = json_response.except('id','created_at','updated_at')
          expect(actual_attr).to eq(expected_attr)
        end
        it "returns Error for invalid Status" do
          post '/api/v1/tasks' , params: {tasks: @task.tasks , status: ''} , headers: @headers
          expect(response).to have_http_status(400)
          expect(json_response['error']).to eq("status does not have a valid value")
        end
        it "return Error for invalid tasks" do
          post '/api/v1/tasks' , params: { status: @task.status} , headers: @headers
          expect(response).to have_http_status(400)
          expect(json_response['error']).to eq("tasks is missing")
        end
        it "returns error for missing parameters" do
          post '/api/v1/tasks' , params: { } , headers: @headers
          expect(response).to have_http_status(400)
          expect(json_response['error']).to eq( "tasks is missing, status is missing, status does not have a valid value")
        end
      end

      context "Get all Task" do
        it "returns a array of tasks " do
          get '/api/v1/tasks', headers: @headers
          expect(response).to have_http_status(200)
          expect(json_response).to be_an(Array)
        end
      end
    end

    context "When not authorized" do
    end

  end



  describe "/api/v1/tasks/:id" do
    context "When authorized" do
      before :all do
        @task = FactoryBot.create(:task, :pending)
        @headers = {'Authorization' => "Bearer #{JwtService.generate_token({user:{user_id:@task.user_id}})}"}
      end

      context "Get Single Task" do
        it "returns a single task" do
          get "/api/v1/tasks/#{@task.id}", headers: @headers
          expect(response).to have_http_status(200)
          expected_attr = JSON.parse(@task.to_json).except('created_at','updated_at')
          actual_attr = json_response.except('created_at','updated_at')
          expect(expected_attr).to eq(actual_attr)
        end

        it "returns an error for invalid id" do
          get '/api/v1/50000'

        end
      end
    end
  end


end

# # spec/api/v1/task_api_spec.rb
# require 'rails_helper'
#
# RSpec.describe V1::TaskApi, type: :request do
#   let(:user) { create(:user) }
#   let(:headers) { { 'Authorization' => JwtService.encode(user_id: user.id) } }
#
#   describe 'POST /v1/tasks' do
#     it 'creates a task' do
#       post '/v1/tasks', params: { tasks: 'Sample Task', status: :pending }, headers: headers
#       expect(response).to have_http_status(201)
#       expect(json_response['message']).to eq('Task created successfully')
#     end
#
#     it 'returns an error for invalid parameters' do
#       post '/v1/tasks', params: { status: :pending }, headers: headers
#       expect(response).to have_http_status(400)
#       expect(json_response['error']).to be_present
#     end
#   end
#
#   describe 'GET /v1/tasks' do
#     it 'gets all tasks' do
#       create_list(:task, 3, user: user)
#       get '/v1/tasks', headers: headers
#       expect(response).to have_http_status(200)
#       expect(json_response).to be_an(Array)
#       expect(json_response.size).to eq(3)
#     end
#   end
#
#   describe 'GET /v1/tasks/:id' do
#     it 'gets a single task' do
#       task = create(:task, user: user)
#       get "/v1/tasks/#{task.id}", headers: headers
#       expect(response).to have_http_status(200)
#       expect(json_response['tasks']).to eq(task.tasks)
#     end
#
#     it 'returns an error for invalid task id' do
#       get '/v1/tasks/999', headers: headers
#       expect(response).to have_http_status(404)
#       expect(json_response['error']).to be_present
#     end
#   end
#
#   describe 'PATCH /v1/tasks/:id' do
#     it 'updates the task' do
#       task = create(:task, user: user)
#       patch "/v1/tasks/#{task.id}", params: { status: :completed }, headers: headers
#       expect(response).to have_http_status(200)
#       expect(json_response['message']).to eq('Task updated successfully')
#     end
#
#     it 'returns an error for invalid task id' do
#       patch '/v1/tasks/999', params: { status: :completed }, headers: headers
#       expect(response).to have_http_status(404)
#       expect(json_response['error']).to be_present
#     end
#   end
#
#   describe 'DELETE /v1/tasks/:id' do
#     it 'deletes the task' do
#       task = create(:task, user: user)
#       delete "/v1/tasks/#{task.id}", headers: headers
#       expect(response).to have_http_status(200)
#       expect(json_response['message']).to eq('Task deleted successfully')
#     end
#
#     it 'returns an error for invalid task id' do
#       delete '/v1/tasks/999', headers: headers
#       expect(response).to have_http_status(404)
#       expect(json_response['error']).to be_present
#     end
#   end
# end
