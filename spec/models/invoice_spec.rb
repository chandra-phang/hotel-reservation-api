require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it { should belong_to(:reservation) }
  it { should belong_to(:creator) }

  it { should validate_presence_of(:total_paid_amount) }
  it { should validate_presence_of(:security_price) }
  it { should validate_presence_of(:total_price) }
  it { should validate_presence_of(:reservation_id) }
end
