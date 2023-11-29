require 'rails_helper'

RSpec.describe "TaskApis", type: :request do
  describe " /api/v1/tasks" do
    context "When authorized" do
      before :all do
        # byebug
        @task = FactoryBot.create(:task, :pending)
        # byebug
        @headers = {'Authorization' => "Bearer #{JwtService.generate_token({user:{user_id:@task.user_id}})}"}
      end

      context "Create Task" do
        it "with valid parameters" do
          # byebug
          post '/api/v1/tasks' , params: {tasks: @task.tasks, status: @task.status} , headers: @headers
          # byebug
          expect(response).to have_http_status(201)
          # byebug
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
      context "Create task" do
        it "return 401" do
          post '/api/v1/tasks' , params: {tasks: "", status: :pending}
          expect(response).to have_http_status(401)
          expect(json_response['error']).to eq("Authorization failed")
        end
      end
      context "Get all task" do
        it "return 401" do
          get '/api/v1/tasks'
          expect(response).to have_http_status(401)
          expect(json_response['error']).to eq("Authorization failed")
        end
      end
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
      end

      context "Update the task" do
        it 'returns the updated task' do
          patch "/api/v1/tasks/#{@task.id}", headers: @headers , params: {status: @task.status}
          expect(response).to have_http_status(200)
          expect(json_response['status']).to eq(@task.status)
        end
        it "returns error for invalid or missing status" do
          patch "/api/v1/tasks/#{@task.id}", headers: @headers , params: {status: "invalid"}
          expect(response).to have_http_status(400)
          expect(json_response['error']).to be_present
        end
      end

      context "Delete the task" do
        it "return 200 with valid id" do
          delete "/api/v1/tasks/#{@task.id}", headers: @headers
          expect(response).to have_http_status(200)
          expect(json_response['message']).to eq("task deleted Successfully")
        end
        it "returns 400 with invalid id" do
          delete "/api/v1/tasks/#{40000}", headers: @headers
          expect(response).to have_http_status(400)
          expect(json_response['error']).to be_present
        end
      end
    end
    context "when not authorized" do
      context "Get single tasks" do
        it "return 401" do
          get '/api/v1/tasks/34'
          expect(response).to have_http_status(401)
          expect(json_response['error']).to eq("Authorization failed")
        end
      end

      context "Update tasks" do
        it "return 401" do
          patch '/api/v1/tasks/34' ,params: {status: :pending}
          expect(response).to have_http_status(401)
          expect(json_response['error']).to eq("Authorization failed")
        end
      end
      context "Delete tasks" do
        it "return 401" do
          delete '/api/v1/tasks/34'
          expect(response).to have_http_status(401)
          expect(json_response['error']).to eq("Authorization failed")
        end
      end
    end
  end
end
