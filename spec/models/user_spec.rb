require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(email: "user@gmail.com", name: "User") }
  it { should have_many(:reservations) }
  it { should have_many(:invoices) }
  it { should have_many(:guests) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
end
