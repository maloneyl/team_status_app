class Duration < ActiveRecord::Base

  attr_accessible :status_id, :time_elapsed

  belongs_to :status

  def self.today
    where("created_at >= ?", Time.zone.now.beginning_of_day)
  end

  def self.yesterday
    where(:created_at => (Time.now.midnight - 1.day)..Time.now.midnight)
  end

end
