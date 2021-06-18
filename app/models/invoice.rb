class Invoice < ApplicationRecord
  belongs_to :reservation
  belongs_to :creator, class_name: "User", foreign_key: :creator_id

  validates :total_paid_amount, presence: true
  validates :security_price, presence: true
  validates :total_price, presence: true
  validates :reservation_id, presence: true
end
