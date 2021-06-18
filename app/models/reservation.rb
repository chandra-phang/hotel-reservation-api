class Reservation < ApplicationRecord
  belongs_to :guest
  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  has_one :invoice

  enum status: {
    accepted: "accepted",
    cancelled: "cancelled",
    deleted: "deleted",
  }

  validates :status, presence: true
  validates :status, inclusion: { in: statuses.keys }

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :nights, presence: true
  validates :total_guest, presence: true
  validates :adult_guest, presence: true
  validates :children_guest, presence: true
  validates :infant_guest, presence: true
  validates :guest_id, presence: true

  validate :valid_period?

  def valid_period?
    return if start_date.blank? && end_date.blank?

    if start_date > end_date
      errors.add(:start_date, "should be earlier than end_date")
    end
  end
end
