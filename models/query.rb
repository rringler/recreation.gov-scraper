class Query < ActiveRecord::Base
  has_many :availabilities, dependent: :destroy

  scope :latest, -> { order(created_at: :desc).limit(1).first }
  scope :older,  ->(n = 3) { where(["created_at < ?", n.days.ago]) }
end
