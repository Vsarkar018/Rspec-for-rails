require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "associations" do
    it 'belongs to user' do
      expect(described_class.reflect_on_association(:user).macro).to eq :belongs_to
    end
  end

  describe  'validations' do
    it 'requires user ' do
      expect(build(:task, user: nil)).not_to be_valid
    end
    it 'requires tasks' do
      expect(build(:task,tasks: nil)).not_to be_valid
    end
    it 'requires status' do
      expect(build(:task,status: nil)).not_to be_valid
    end
    it 'requires valid status' do
      expect(build(:task,status: :pending)).to be_valid
      expect(build(:task,status: :inprogress)).to be_valid
      expect(build(:task,status: :completed)).to be_valid
      expect(build(:task,status: :discarded)).to be_valid
    end
  end

  describe "Task Operations" do
    before(:each) do
      @task = FactoryBot.create(:task, :pending)
    end
    it "create new task" do
      expect(@task).to be_valid
    end
    it 'updates existing task' do
      @task.update(status: :completed)
      expect(@task.reload.status).to eq('completed')
    end
    it 'reads an existing task' do
      expect(Task.find(@task.id)).to eq(@task)
    end
    it 'deletes an existing task' do
      expect{@task.destroy}.to change(Task, :count).by(-1)
    end
  end


end
