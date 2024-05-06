require 'rails_helper'
RSpec.describe Package, type: :model do
  describe "associations" do
    it { should have_many(:users) }
    it { should have_many(:payments) }
    it {should define_enum_for(:name).with_values(starter: 0, basic: 1, advance: 2) }
  end
end
