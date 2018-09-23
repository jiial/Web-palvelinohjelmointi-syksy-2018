class User < ApplicationRecord
  has_many :ratings, dependent: :destroy # käyttäjällä on monta ratingia
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, format: { with: /^(?=.*?[A-Z])(?=.*\d)[\w-]{6,30}$/, multiline: true, message: "must be at least 4 characters and include one number and one Uppercase letter." }

  has_secure_password

  include RatingAverage
end
