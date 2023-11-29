module V1
  module Helpers
    class TaskHelper
      class Error < StandardError
        attr_reader :status

        def initialize(message,status)
          @status = status
        end
      end

      def create_task(user_id,params)
        Task.create!(user_id:user_id,tasks:params[:tasks],status:params[:status])
      rescue => error
        raise error
      end

      def get_all_tasks(user_id)
        tasks = Task.where(user_id:user_id)
        if tasks
          tasks
        else
          raise Error.new("Unable to fetch tasks",500)
        end
      end
      def get_task(id)
        task = Task.find_by_id(id)

        if task.blank?
          raise Error.new("Unable to the fetch the task", 500)
        else
          task
        end
      end

      def update_task(params)
        task = Task.find(params[:id])
        task.status = params[:status]
        if task.save
          task
        else
          raise Error.new("Unable to update the task",500)
        end
      end

      def delete_task(id)
        task = Task.delete(id)
        if task ==1
          status = 200
          {message: "task deleted Successfully"}
        elsif task == 0
          raise Error.new("Task with id #{id} doesn't exits",400)
        else
          raise Error.new("Unable to delete the task",500)
        end
      end
    end
  end
end
