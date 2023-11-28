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
        task = Task.create!(user_id:user_id,tasks:params[:tasks],status:params[:status])
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
        task = Task.find(id)
        p task
        byebug
        if task.eql?(nil)
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
        task = Task.delete(id:id)
        if task ==1 || task == 0
          task
        else
          raise Error.new("Unable to delete the task",500)
        end
      end
    end
  end
end
