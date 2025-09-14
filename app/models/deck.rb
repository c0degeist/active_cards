class Deck < ApplicationRecord

  belongs_to :topic
  has_many :cards, class_name: "ActiveCard"

  validates :title, presence: true, length: { maximum: 30 }, uniqueness: { scope: :topic_id, case_sensitive: false }
  validates :topic, presence: true

  scope :ordered, -> { order(title: :asc) }

  def cards_count
    cards.count
  end

  def pending_cards
    cards.pending
  end

  # TODO: Was wenn next_recall in der Vergangenheit liegt?
  # + SPECS
  def next_recall
    cards.minimum(:next_recall)
  end

  def to_s
    title
  end

end
