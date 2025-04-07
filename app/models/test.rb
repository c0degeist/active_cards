# Akzepntanzkriterien:
# Beim Erstellen eines Tests, sollen X TestCards auf Basis von Zufällig ausgewählten Cards erstellt werden.
# Die Test Cards bekommen eine feste reihenfolge.
# Zu Einem Späteren Zeitpunkt, soll das Scope, aus dem die Zufällig ausgewählten Cards kommen, selbst gewählt werden können.
# Z Einem noch Späteren Zeitpunkt, soll man die Cards für die Abfrage komplett selbst wählen können.

class Test < ApplicationRecord
  include RailsStateMachine::Model

  MAXIMUM_CARDS_COUNT = 10

  belongs_to :topic
  has_many :cards, class_name: "Test::Card", dependent: :destroy

  # validates :cards_count, numericality: { greater_than: 0, only_integer: true }
  # validate :validate_maximum_cards_count

  # Das ist nicht so geil. Was wenn beim erstellen der TestCards etwas schief geht?
  # Eigentlich möchte man das alles in einer Transaction machen.
  # D.h. man braucht ein FormModel oder eine andere ServiceKlasse die das erstellen dieser Sachen übernimmt.
  # Das Model an sich, sollte nicht dafür verantwortlich sein diese ganzen Daten an zu legen.
  # Dort kann man sich dann komplett austoben bei der Implementierung.
  # TODO: Test::Form erstellen, und die Logik für das generieren eines korrekten Tests dort rein schieben.
  after_commit :create_test_cards, on: :create

  scope :finished, -> { where(state: STATE_FINISHED) }
  scope :started, -> { where(state: STATE_STARTED) }

  state_machine do
    state :started, initial: true
    state :finished

    event :finish do
      transitions from: :started, to: :finished

      # TODO: Wir dürfen diese transition nur nehmen, wenn alle cards :finished sind.
    end
  end

  # Auch diese Methode sollte vmtl in einem Form Model liegen.
  def next_card
    cards.unfinished.first
  end

  def unfinished_cards
    cards.unfinished
  end

  # TODO: Diesen Wert will man evtl cachen
  def correctly_answered_count
    cards.correct.count
  end

  def score
    ((correctly_answered_count / cards_count.to_f) * 100).round(2)
  end

  def to_s
    "Test vom #{created_at.strftime("%d.%m.%Y")}"
  end

  private

  # def validate_maximum_cards_count
  #   return if deck.blank? || cards_count.blank?
  #
  #   if cards_count > deck.cards_count
  #     errors.add(:cards_count, "darf nicht größer sein als die Anzahl der Karten im zugehörigen Deck (#{deck.cards_count})")
  #   end
  # end

  def create_test_cards
    random_active_cards = topic.pending_cards.order(Arel.sql("RANDOM()")).limit(MAXIMUM_CARDS_COUNT)

    random_active_cards.each do |active_card|
      test_card = Test::Card.new(test: self, active_card: active_card)
      test_card.save!
    end
  end

end
