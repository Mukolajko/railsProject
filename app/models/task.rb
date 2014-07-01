class Task < ActiveRecord::Base
  belongs_to :user
  has_many :sharedtasks
  has_many :users, :through => :sharedtasks
  attr_accessible :description, :taskname, :user_id, :status

  def usersintask
  	@usersintask ||= users.map(&:username).join(",") 
  end

  state_machine :status, :initial => :new do
  	event :new do
	  transition :qa => :new
	  transition :cannot_reproduce => :new
	end
	event :in_progress do
	  transition :new => :in_progress
	end
	event :fixed do
	  transition :in_progress => :fixed
	end
	event :cannot_reproduce do
	  transition :in_progress => :cannot_reproduce
	end
	event :qa do
	  transition :fixed => :qa
	end
	event :done do
	  transition :qa => :done
	end
	event :close do
	  transition :qa => :close
	  transition :done => :close
	  transition :cannot_reproduce => :close
	end
  end
end 