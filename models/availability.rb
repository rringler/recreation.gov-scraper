class Availability < ActiveRecord::Base
  belongs_to :query, dependent: :destroy

  validates :site, presence: true
  validates :date, presence: true
end
