class CreateSharedtasks < ActiveRecord::Migration
  def change
    create_table :sharedtasks do |t|
      t.belongs_to :user
      t.belongs_to :task
    end
  end
end
