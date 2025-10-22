class Topic < ApplicationRecord

  has_many :decks
  has_many :cards, through: :decks

  validates :title, presence: true, length: { maximum: 30 }

  scope :ordered, -> { order(:title) }

  def decks_count
    decks.size
  end

  # TODO: Wie viele Queries werden bei dieser Methode abgefeuert?
  # Wie lässt sich das eventuell optimieren?
  # Brauche ich diese Methode überhaupt? Topic hat has_many :cards
  def cards_count
    decks.sum(&:cards_count)
  end

  def pending_cards
    cards.pending
  end

  # TODO: Im Idealfall, sollte #next_recall zurückgeben, wann die nächsten MIN_CARDS_FOR_TEST_COUNT bereit zur abfrage sind.
  # TODO: Ich muss hier nicht über Decks gehen. Eigentlich müsste ich über #cards gehen können.
  def next_recall
    decks.map(&:next_recall).compact.min
  end

  def to_s
    title
  end

end
