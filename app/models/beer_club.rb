class BeerClub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, -> { distinct }, through: :memberships, source: :user

  def to_s
    "#{name} "
  end
end
