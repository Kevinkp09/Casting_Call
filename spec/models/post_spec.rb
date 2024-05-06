require 'rails_helper'
RSpec.describe Post, type: :model do
   subject { Post.new( title: 'Dange', age: '23', location: 'Nikol', role: "artist main lead", audition_type: "offline", category: "artist") }
   describe "associations" do
    it { should have_many(:requests) }
    it { should belong_to(:agency).class_name('User').with_foreign_key(:agency_id) }
    it { should define_enum_for(:role).with_values("artist main lead": 0, "supporting role": 1, "jr artist": 2) }
    it { should define_enum_for(:category).with_values(artist: 0, dancer: 1, singer: 2) }
    it { should define_enum_for(:audition_type).with_values("offline": 0, "online": 1) }
    it { should define_enum_for(:skin_color).with_values(fair: 0, light: 1, dark: 2) }
   end
end
