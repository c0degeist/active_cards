class Deck < ApplicationRecord

  belongs_to :topic
  has_many :cards, class_name: "ActiveCard"

  # TODO: validate uniqenuess
  validates :title, presence: true, length: { maximum: 30 }
  validates :topic, presence: true

  scope :ordered, -> { order(title: :asc) }

  # TODO: Spec
  def cards_count
    cards.count
  end

  def pending_cards
    cards.pending
  end

  def next_recall
    cards.minimum(:next_recall)
  end

  def to_s
    title
  end

end
