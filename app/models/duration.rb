class Duration < ActiveRecord::Base

  attr_accessible :status_id, :time_elapsed

  belongs_to :status
end
