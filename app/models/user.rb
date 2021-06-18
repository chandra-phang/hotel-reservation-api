class User < ApplicationRecord
  has_secure_password

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  enum state: {
    active: "active",
    deleted: "deleted",
  }

  has_many :reservations, foreign_key: :creator_id
  has_many :invoices, foreign_key: :creator_id
  has_many :guests, foreign_key: :creator_id

  validates :name, presence: true
  validates :state, presence: true
  validates :state, inclusion: { in: states.keys }
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: EMAIL_REGEX
end
