require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
  
  it "is not saved if password is too short" do
    user = User.create username:"Pekka", password:"S1", password_confirmation:"S1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
  
  it "is not saved if password contains only letters" do
    user = User.create username:"Pekka", password:"Salasana", password_confirmation:"Salasana"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
  
  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end
    
    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end
    
    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)
      expect(user.favorite_beer).to eq(best)
    end
  end
  
  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }
    
    it "has method for determining one" do
      user.should respond_to :favorite_style
    end
    
    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end
    
    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_style).to eq(beer.style)
    end
    
    it "is the only rated style if only one style has ratings" do
      beer = create_beer_with_rating(10, user)
      create_beers_with_ratings(11, 12, 13, user)

      expect(user.favorite_style).to eq(beer.style)
    end
    
    it "is the style with highest average rating if many styles have ratings" do
      create_beers_with_ratings(10, 15, user)
      bbeer = FactoryGirl.create(:beer2)
      FactoryGirl.create(:rating, score:30, beer:bbeer, user:user)
      expect(user.favorite_style).to eq(bbeer.style)
    end
  end
  
  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }
    
    it "has method for determining one" do
      user.should respond_to :favorite_brewery
    end
    
    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end
    
    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_brewery.name).to eq(beer.brewery.name)
    end
    
    it "is the only rated brewery if only one brewery has ratings" do
      beer = create_beer_with_rating(10, user)
      create_beers_with_ratings(11, 12, 13, user)

      expect(user.favorite_brewery.name).to eq(beer.brewery.name)
    end
    
    it "is the brewery with highest average rating if many breweries have ratings" do
      create_beers_with_ratings(10, 15, user)
      bbrewery = FactoryGirl.create(:brewery2)
      bbeer = FactoryGirl.create(:beer2, brewery:bbrewery)
      FactoryGirl.create(:rating, score:30, beer:bbeer, user:user)
      expect(user.favorite_brewery.name).to eq(bbeer.brewery.name)
    end
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do

      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end

def create_beer_with_rating(score, user)
      beer = FactoryGirl.create(:beer)
      FactoryGirl.create(:rating, score:score, beer:beer, user:user)
      beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end
