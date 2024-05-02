require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new( email: 'kevin1234@gmail.com', password: '123456', mobile_no: '7649876578',  username: 'kevin', role: "artist", ) }
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
    it 'is not valid without a username' do
      subject.username = nil
      expect(subject).to_not be_valid
    end
    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).to_not be_valid
    end
    it 'is not valid if the mobile_no is not 10 digits' do
      expect(subject.mobile_no.length).to eq(10)
    end
    it 'validates presence of password' do
      subject.password = nil
      expect(subject).to_not be_valid
    end
    it 'validates minumum length of password' do
      subject.password = '123456'
      expect(subject).to be_valid
    end
    it 'validates maximum length of password' do
      subject.password = '12345678901234567890123456789012'
      expect(subject).to be_valid
    end
    it "validates presence of role" do
      subject.role = nil
      expect(subject).to_not be_valid
    end
  end
  describe "associations" do
    it { should belong_to(:package).class_name('Package').with_foreign_key(:package_id).optional }
    it { should have_many(:works) }
    it { should have_many(:requests) }
    it { should have_many(:posts).with_foreign_key(:agency_id) }
    it { should have_one_attached(:profile_photo) }
    it {should define_enum_for(:role).with_values(artist: 0, agency: 1, admin: 2) }
    it {should define_enum_for(:skin_color).with_values(fair: 0, light: 1, dark: 2) }
  end
end
