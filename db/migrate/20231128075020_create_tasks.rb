class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :tasks
      t.references :user, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
