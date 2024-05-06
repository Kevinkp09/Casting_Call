require 'rails_helper'
RSpec.describe Request, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
    it {should define_enum_for(:status).with_values(waiting: 0, shortlisted: 1, rejected: 2) }
    it {should define_enum_for(:apply_status).with_values(apply: 0, applied: 1) }
  end
end
