class Deck < ApplicationRecord

  has_many :cards, class_name: "ActiveCard"

  # TODO: validate uniqenuess
  validates :title, presence: true, length: { maximum: 30 }

  scope :ordered, -> { order(title: :asc) }

  # TODO: Spec
  def cards_count
    cards.count
  end

  def to_s
    title
  end

end
