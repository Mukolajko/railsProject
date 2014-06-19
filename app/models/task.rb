class Task < ActiveRecord::Base
  attr_accessible :description, :taskname, :username

  def self.user_tasks(username)
  	tasks = find_by_username(username) ? where("username = ?", username) : nil
  end
end
