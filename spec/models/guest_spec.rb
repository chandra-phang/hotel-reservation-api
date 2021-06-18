require 'rails_helper'

RSpec.describe Guest, type: :model do
  it { should have_many(:reservations) }
  it { should belong_to(:creator) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:phone_number) }
end
