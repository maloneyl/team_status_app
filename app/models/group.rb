class Group < ActiveRecord::Base

  attr_accessible :name, :owner_id

  has_and_belongs_to_many :users
end
