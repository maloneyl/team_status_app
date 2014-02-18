class Duration < ActiveRecord::Base

  attr_accessible :status_id, :time_elapsed

  belongs_to :status

  def self.today
    where("created_at >= ?", Time.zone.now.beginning_of_day)
  end

  def self.yesterday
    where(:created_at => (Time.now - 1.day).beginning_of_day..(Time.now - 1.day).end_of_day) # note: this returns something like "statuses"."created_at" BETWEEN '2014-02-17 00:00:00.000000' AND '2014-02-18 00:00:00.000000', NOT 02-17 23:59:59
  end

end
