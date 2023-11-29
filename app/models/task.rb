class Task < ApplicationRecord
  belongs_to :user
  enum status: [:completed, :pending, :inprogress, :discarded]

  validates :tasks, presence: true
  validates :status, presence: true
  validates :user, presence:true
end
