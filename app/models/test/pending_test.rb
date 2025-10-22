class Test
  class PendingTest

    # TODO: Brauche ich den MIN_CARDS_COUNT_FOR_TEST?
    # Falls ja, sollte ich im Dashboard vermutlich besseres Feedback in der UI geben.
    # Sowas wie: "Es stehen 3 cards zur Abfrage bereit. Weitere 7 Fehlen"
    # Allgemein sollte das Feedback verbessert werden. z.B. Wass wen das Deck überhaupt weniger Cards hat als MIN_CARDS_COUNT_FOR_TEST
    # -> "Dieses Topic hat noch nicht genug Cards für einen Test. Mindestens X Cards werden benötigt"
    # Außedem sollte diese Konstante vermutlich nicht in dieser Klasse leben?
    MIN_CARDS_COUNT_FOR_TEST = 1

    attr_reader :topic

    delegate :decks, :decks_count, :cards_count, to: :topic

    def initialize(topic)
      @topic = topic
    end

    def ready?
      pending_cards_count >= MIN_CARDS_COUNT_FOR_TEST
    end

    def pending_cards_count
      pending_cards.count
    end

    def pending_cards
      @pending_cards ||= decks.collect(&:pending_cards).flatten
    end

    def next_recall
      @next_recall ||= @topic.next_recall
    end

    def days_till_next_test
      (next_recall.to_date - Date.today).to_i if next_recall
    end

  end
end
