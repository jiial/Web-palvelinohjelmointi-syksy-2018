class Style < ApplicationRecord
  has_many :beers
  has_many :ratings, through: :beers

  include RatingAverage

  def self.top(amount)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |s| -(s.average_rating || 0) }
    sorted_by_rating_in_desc_order.take(amount)
  end
end
