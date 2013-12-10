class User < ActiveRecord::Base

  # Others available are: :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  # will need to add to model: name, handle

  has_and_belongs_to_many :groups
end
