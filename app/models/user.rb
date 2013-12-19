class User < ActiveRecord::Base

  # Others available are: :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
    # , :confirmable

  attr_accessible :email, :first_name, :last_name, :username, :password, :password_confirmation, :remember_me

  validates_uniqueness_of :username

  has_and_belongs_to_many :groups
  has_many :statuses
  has_many :agendas

  def full_name
   "#{self.first_name} #{self.last_name}"
  end

end
