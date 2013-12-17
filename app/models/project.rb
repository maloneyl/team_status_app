class Project < ActiveRecord::Base

  # probably won't use this after all...

  attr_accessible :name

  belongs_to :group
  has_many :statuses
end
