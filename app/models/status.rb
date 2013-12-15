class Status < ActiveRecord::Base

  attr_accessible :body, :tracking

  belongs_to :group
  belongs_to :user
  belongs_to :project

  def self.today
    where("created_at >= ?", Time.zone.now.beginning_of_day)
  end

  def self.yesterday
    where(:created_at => (Time.now.midnight - 1.day)..Time.now.midnight)
  end

  # find all statuses that are actually related to work items, not simply messages
  def self.trackable
    where("tracking = ? OR duration > ?", true, 0) # EQUIVALENT TO: all(:conditions => ['tracking = ? OR duration >= ?', true, 0])
  end

  def self.with_mentions
    where(['body LIKE ?', '@%'])
  end

  def at_user
    body.scan(/(?<=^@)\w+(?=[\s|~])/).first # => "maloney" (example)
  end

  # def seconds_to_units(seconds)
  #   '%d days, %d hours, %d minutes, %d seconds' % [24,60,60].reverse.inject([seconds]) do |result, unitsize| # the .reverse lets us put the larger units first for readability
  #     result[0,0] = result.shift.divmod(unitsize)
  #     result
  #   end
  # end

end
