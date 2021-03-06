class Project < ApplicationRecord
  belongs_to :charity
  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings
  has_many :likes, dependent: :destroy
  has_one_attached :photo
  has_one_attached :file

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
