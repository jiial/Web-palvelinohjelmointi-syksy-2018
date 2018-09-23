class Brewery < ActiveRecord::Base
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   only_integer: true }
  validate :year_cannot_be_more_than_current_year

  include RatingAverage

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2018
    puts "changed year to #{year}"
  end

  def year_cannot_be_more_than_current_year
    if year > Time.now.year
      errors.add(:Founding_date, "can't be in the future")
    end
  end
end
