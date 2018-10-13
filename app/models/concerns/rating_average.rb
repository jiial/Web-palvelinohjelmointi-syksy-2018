module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    if ratings
      ratings.average(:score)
    else
      0
    end
  end
end
