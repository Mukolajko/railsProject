class Task < ActiveRecord::Base
  belongs_to :user
  has_many :sharedtasks
  has_many :users, :through => :sharedtasks
  attr_accessible :description, :taskname, :user_id

end 