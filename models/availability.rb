class Availability < ActiveRecord::Base
  belongs_to :query

  validates :site, presence: true
  validates :date, presence: true
end
