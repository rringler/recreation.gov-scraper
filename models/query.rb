class Query < ActiveRecord::Base
  has_many :availabilities

  scope :latest, -> { order(created_at: :desc).limit(1).first }
end
