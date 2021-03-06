class Status < ActiveRecord::Base

  attr_accessible :body, :tracking, :tracked, :user_id, :group_id

  validates_presence_of :body

  belongs_to :group
  belongs_to :user
  belongs_to :project
  has_many :durations, :dependent => :destroy

  after_save :update_duration

  def update_duration
    if self.tracked?
      if self.durations.last.present?
        duration_to_add = (self.updated_at - self.durations.last.updated_at).to_i
      else
        duration_to_add = 0
      end
      Duration.create!(:status_id => self.id, :time_elapsed => duration_to_add)
    end
  end

  def self.today
    where("created_at >= ?", Time.zone.now.beginning_of_day)
  end

  def self.yesterday
    where(:created_at => (Time.now.midnight - 1.day)..Time.now.midnight)
  end

  def self.trackable
    where(:tracked => true)
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
