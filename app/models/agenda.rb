class Agenda < ActiveRecord::Base

  attr_accessible :body, :group_id, :user_id

  belongs_to :group
  belongs_to :user

  def self.today
    where("updated_at >= ?", Time.zone.now.beginning_of_day)
  end
end
