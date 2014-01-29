class User < ActiveRecord::Base
  include RatingAverage
  
  has_secure_password
  
  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 15 }
  validates :password, :format => {:with => /.*(?=.{4,})(?=.*\d)(?=.*[A-Z]).*/}
  
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :membership
  
end
