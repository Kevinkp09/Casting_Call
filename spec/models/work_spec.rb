require 'rails_helper'
RSpec.describe Post, type: :model do
  subject { Work.new( youtube_link: "youtubelink", user_id: 1) }
  describe "validations" do
    it 'is not valid with invalid format of youtube link ' do
      expect(subject).to_not be_valid
    end
    #  it 'is valid with valid format of youtube link ' do
    #   subject.youtube_link = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    #   expect(subject).to be_valid
    # end
  end

  describe "associations" do
    it { should belong_to(:user).class_name('User').with_foreign_key(:user_id) }
  end
end
