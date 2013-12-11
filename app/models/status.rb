class Status < ActiveRecord::Base

  attr_accessible :body, :tracking

  belongs_to :group
  belongs_to :user
  belongs_to :project
end
