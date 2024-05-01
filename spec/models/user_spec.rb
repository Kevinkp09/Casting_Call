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
    it "should have one attached profile photo" do
      expect(User.new).to respond_to(:profile_photo)
    end

    it "should belong to a package" do
      expect(User.reflect_on_association(:package).macro).to eq(:belongs_to)
    end

    it "should have many works" do
      expect(User.reflect_on_association(:works).macro).to eq(:has_many)
    end

    it "should have many payments" do
      expect(User.reflect_on_association(:payments).macro).to eq(:has_many)
    end

    it "should have many requests" do
      expect(User.reflect_on_association(:requests).macro).to eq(:has_many)
    end
  end
end
