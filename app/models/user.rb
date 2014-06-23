class User < ActiveRecord::Base
  has_many :tasks
  attr_accessible :username, :email, :password, :password_confirmation
  attr_accessor :password	

  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :username
  validates_uniqueness_of :email, :username

  def self.authenticate(login,password)
    user = find_by_email(login)
    user = find_by_username(login) unless user
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end	
  end
end
