class User < ActiveRecord::Base
  has_many :sharedtasks
  has_many :tasks, :through => :sharedtasks
  has_attached_file :avatar, :styles => {:medium => "250x250"}
  attr_accessor :password	

  before_save :encrypt_password
  validates_attachment_content_type :avatar, :content_type => /.(?:jpe?g|png|gif)$/
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
