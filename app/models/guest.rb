class Guest < ApplicationRecord
  has_many :reservations
  belongs_to :creator, class_name: "User", foreign_key: :creator_id

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  validates :email, presence: true
  validates_format_of :email, with: EMAIL_REGEX
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true
end
