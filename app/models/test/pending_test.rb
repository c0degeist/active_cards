class Test
  class PendingTest

    MIN_CARDS_COUNT_FOR_TEST = 10

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
