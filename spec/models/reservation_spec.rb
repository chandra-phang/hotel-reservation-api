require 'rails_helper'

RSpec.describe Reservation, type: :model do
  it { should belong_to(:guest) }
  it { should belong_to(:creator) }
  it { should have_one(:invoice) }

  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:nights) }
  it { should validate_presence_of(:total_guest) }
  it { should validate_presence_of(:adult_guest) }
  it { should validate_presence_of(:children_guest) }
  it { should validate_presence_of(:infant_guest) }
  it { should validate_presence_of(:guest_id) }
end
