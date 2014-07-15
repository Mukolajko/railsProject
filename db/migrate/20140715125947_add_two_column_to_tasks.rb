class AddTwoColumnToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :task_number, :integer
    add_column :tasks, :task_type, :string
  end
end
