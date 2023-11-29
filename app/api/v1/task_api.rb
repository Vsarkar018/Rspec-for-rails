module V1
  class TaskApi < Grape::API
    version 'v1', using: :path
    format :json

    AUTH_HELPER = Helpers::AuthHelper
    TASK_HELPER = Helpers::TaskHelper


    rescue_from TASK_HELPER::Error do |e|
      error!({error:e.message},e.status)
    end
    rescue_from AUTH_HELPER::Error do |e|
      error!({error:e.message},e.status)
    end
    resource :tasks do
      desc "Create a task"

      params do
        requires :tasks, type: String, desc: "Task that has to be created"
        requires :status, type: Symbol, values: [:completed, :pending, :inprogress, :discarded], desc: "Status of the task"
      end
      post do
        token = AUTH_HELPER.new.verify_token(headers["Authorization"])
        data = JwtService.decode(token)
        task = TASK_HELPER.new.create_task(data[:user][:user_id],params)
      end

      desc "Get all tasks"
      get do
        token = AUTH_HELPER.new.verify_token(headers['Authorization'])
        data = JwtService.decode(token)
        tasks = TASK_HELPER.new.get_all_tasks(data[:user][:user_id])
      end



      desc "Get a single task"
      get ':id' do
        AUTH_HELPER.new.verify_token(headers["Authorization"])
        task = TASK_HELPER.new.get_task(params[:id])
      end

      desc "Update the task"
      params do
        requires :status, type: Symbol, values: [:completed, :pending, :inprogress, :discarded], desc: "Status of the task"
      end
      patch ':id' do
        AUTH_HELPER.new.verify_token(headers["Authorization"])
        task = TASK_HELPER.new.update_task(params)
      end

      desc "Delete the task"
      delete ':id' do
        AUTH_HELPER.new.verify_token(headers["Authorization"])
        TASK_HELPER.new.delete_task(params[:id])
      end
    end
  end
end