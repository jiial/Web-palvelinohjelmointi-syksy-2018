require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }
    let(:style) { FactoryBot.create(:style) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  it "is not saved with a password that is too short" do
    user = User.create username:"Pekka", password:"a1", password_confirmation:"a1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end  

  it "is not saved with a password that has no numbers" do
    user = User.create username:"Pekka", password:"aAAAa", password_confirmation:"aAAAa"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
  
  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25 )

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }
    let(:style){ FactoryBot.create(:style) }
    let(:style2){ FactoryBot.create(:style, name:"IPA") }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end  

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end  

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest average rating if several rated" do
      beer1 = create_beer_with_style_and_rating({ user: user }, 20, 1, style)
      beer2 = create_beer_with_style_and_rating({ user: user }, 22, 2, style2)
      beer3 = create_beer_with_style_and_rating({ user: user }, 22, 2, style2)
      best = create_beer_with_style_and_rating({ user: user }, 25, 1, style)

      expect(user.favorite_style).to eq(best.style)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }
    let(:style){ FactoryBot.create(:style) }
    let(:style2){ FactoryBot.create(:style, name:"IPA") }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end  

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the one with highest average rating if several rated" do
      beer1 = create_beer_with_style_and_rating({ user: user }, 20, 1, style)
      beer2 = create_beer_with_style_and_rating({ user: user }, 22, 2, style2)
      beer3 = create_beer_with_style_and_rating({ user: user }, 22, 2, style2)
      best = create_beer_with_rating({ user: user }, 25 )

      expect(user.favorite_brewery).to eq(best.brewery)
    end
  end
end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end

def create_beer_with_style_and_rating(object, score, style_id, style)
  beer = FactoryBot.create(:beer, style_id: style_id, style: style)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end