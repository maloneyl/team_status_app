class Group < ActiveRecord::Base

  attr_accessible :name, :owner_id
  validates_presence_of :name
  validates_uniqueness_of :name

  has_and_belongs_to_many :users
  has_many :statuses, :dependent => :destroy
  has_many :agendas, :dependent => :destroy
end
