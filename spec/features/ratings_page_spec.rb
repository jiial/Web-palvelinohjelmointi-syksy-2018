require 'rails_helper'

include Helpers

describe "Ratings page" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, username:"Paavo" }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when a rating is given, it's registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3, Koff', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')
    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "should not have any before been created" do
    visit ratings_path
    expect(page).to have_content 'List of ratings (0)'
  
  end
  
  describe "when ratings exists" do
    before :each do
      @ratings = [10, 20, 30]
      @ratings.each do |rating_score|
        FactoryBot.create(:rating, score: rating_score, beer_id: 1, user: user)
      end
  
      visit ratings_path
    end
  
    it "it lists the ratings and their total number" do
      expect(page).to have_content "List of ratings (#{@ratings.count})"
      @ratings.each do |rating_score|
        expect(page).to have_content rating_score
      end
    end

    it "they are also listed on user page" do
      FactoryBot.create(:rating, score: 17, beer_id: 2, user: user2)
      visit user_path(user)
      expect(page).to have_content "has made #{@ratings.count} ratings, average rating 20.0"
      @ratings.each do |rating_score|
        expect(page).to have_content rating_score
      end
    end

    it "a rating can be deleted correctly" do
      visit user_path(user)
        click_link(id="1")
        expect(page).to have_content "has made #{@ratings.count-1} ratings, average rating 25.0"
      end
  end
end