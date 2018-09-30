class User < ApplicationRecord
  has_many :ratings, dependent: :destroy # käyttäjällä on monta ratingia
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, format: { with: /^(?=.*?[A-Z])(?=.*\d)[\w-]{4,30}$/, multiline: true, message: "must be at least 4 characters and include one number and one Uppercase letter." }

  has_secure_password

  include RatingAverage

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    styles = ["Weizen", "Lager", "Pale ale", "IPA", "Porter"]

    scores = styles.map { |s| style_average(s) }
    styles.select { |s| (style_average(s) == scores.max) }.first
  end

  def style_average(style)
    ratings_with_selected_style = ratings.select { |r| (r.beer.style == style) }
    return 0 if ratings_with_selected_style.count.zero?

    ratings_with_selected_style.map(&:score).sum * 1.0 / ratings_with_selected_style.count
  end

  def favorite_brewery
    return nil if ratings.empty?

    breweries = beers.map(&:brewery)

    scores = breweries.map { |b| brewery_average(b) }
    breweries.select { |b| (brewery_average(b) == scores.max) }.first
  end

  def brewery_average(brewery)
    ratings_with_selected_brewery = ratings.select { |r| (r.beer.brewery == brewery) }
    return 0 if ratings_with_selected_brewery.count.zero?

    ratings_with_selected_brewery.map(&:score).sum * 1.0 / ratings_with_selected_brewery.count
  end
end
