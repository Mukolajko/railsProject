class Sharedtask < ActiveRecord::Base
  belongs_to :user
  belongs_to :task		
  attr_accessible :user_id, :task_id
end
