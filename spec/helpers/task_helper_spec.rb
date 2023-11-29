require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TaskHelper. For example:
#
# describe TaskHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe V1::Helpers::TaskHelper, type: :helper do
  before :each do
    @user = FactoryBot.create(:user)
  end
  describe "Create Task" do
    it "creates a task successfully" do
      params = {tasks: 'Test Task',status: "pending"}
      expect{described_class.new.create_task(@user.id,params)}.to change(Task, :count).by(1)
    end
    it "raises error if it fails" do
      params = {tasks: 'Test Task',status: "pending"}
      expect{described_class.new.create_task(-1,params)}.to raise_error(StandardError)
    end
  end

  describe "get all task" do
    it "returns all task for a user" do
      task = FactoryBot.create(:task,status: :pending, user: @user)
      res = described_class.new.get_all_tasks(@user.id)
      expect(res.pluck).to be_an(Array)
    end
    it "returns error if it is unable to fetch the task" do
      expect { described_class.new.get_all_tasks(-1) }.to raise_error(described_class::Error)
    end
  end


  before(:each) do
    @task = FactoryBot.create(:task,status: :pending, user:@user)
  end


  describe "get task" do
    it "returns a single task using id" do
      expect(described_class.new.get_task(@task.id)).to eq(@task)
    end
    it 'raises an error if unable to fetch the task' do
      expect { described_class.new.get_task(-1) }.to raise_error(described_class::Error)
    end
  end

  describe "update task" do
    it "returns the updated task" do
      params = {id:@task.id, status: :completed}
      update_task = described_class.new.update_task(params)
      expect(update_task.status).to eq('completed')
    end
    it "return error if unable to update the task" do
      # expect
    end
  end


  describe  "delete task" do
    it "returns the number of rows affected" do
      expect { described_class.new.delete_task(@task.id) }.to change(Task, :count).by(-1)
    end
    it "returns error if it fails to delete the task" do

    end
  end
end
