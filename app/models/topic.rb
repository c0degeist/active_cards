class Topic < ApplicationRecord

  has_many :decks

  validates :title, presence: true

  scope :ordered, -> { order(:title) }

  def decks_count
    decks.count
  end

  def cards_count
    decks.sum(&:cards_count)
  end

  # TODO: Im Idealfall, sollte #next_recall zurückgeben, wann die nächsten MIN_CARDS_FOR_TEST_COUNT bereit zur abfrage sind.
  def next_recall
    decks.map(&:next_recall).compact.min
  end

  def to_s
    title
  end

end
