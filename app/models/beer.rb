class Beer < ActiveRecord::Base
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style_id, presence: true

  include RatingAverage

  def to_s
    "#{name}, #{brewery.name}"
  end

  def self.top(amount)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating || 0) }
    sorted_by_rating_in_desc_order.take(amount)
  end
end
