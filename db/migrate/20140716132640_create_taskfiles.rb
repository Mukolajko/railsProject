class CreateTaskfiles < ActiveRecord::Migration
  def change
    create_table :taskfiles do |t|
      t.belongs_to :task
      t.integer :user_id
      t.attachment :file
    end
  end
end
