class Status < ActiveRecord::Base

  attr_accessible :body, :tracking

  belongs_to :group
  belongs_to :user
  belongs_to :project

  def self.today
    where("created_at >= ?", Time.zone.now.beginning_of_day)
  end

  # find all statuses that are actually related to work items, not simply messages
  def self.trackable
    where("tracking = ? OR duration > ?", true, 0) # EQUIVALENT TO: all(:conditions => ['tracking = ? OR duration >= ?', true, 0])
  end

end
