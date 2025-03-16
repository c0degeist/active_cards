class Test
  class Card < ApplicationRecord
    include RailsStateMachine::Model

    ATTRIBUTES_FROM_ACTIVE_CARD = [
      :answer,
      :explanation,
      :question
    ]

    belongs_to :test
    belongs_to :active_card

    scope :pending, -> { where(state: STATE_PENDING) }
    scope :review, -> { where(state: STATE_REVIEW) }
    scope :unfinished, -> { where(state: [STATE_PENDING, STATE_REVIEW]) }
    scope :finished, -> { where(state: STATE_FINISHED) }
    scope :correct, -> { finished.where(answered_correctly: true) }

    before_validation :copy_attributes_from_active_card, on: :create

    state_machine do
      state :pending, initial: true
      state :review
      state :finished

      event :answered do
        transitions from: :pending, to: :review

        # TODO: Zustandsübergang kann nur genommen werden, wenn user_answer Inhalt hat.
      end

      event :reviewed do
        transitions from: :review, to: :finished

        # TODO: Zustandsübergang kann nur genommen werden, wenn #answered_correctly Inhalt hat.
        after_save do
          active_card.last_recal = DateTime.now

          if answered_correctly?
            active_card.level_up!
          else
            active_card.reset_level!
          end
        end
      end
    end

    private

    def copy_attributes_from_active_card
      self.attributes = active_card.attributes.with_indifferent_access.slice(*ATTRIBUTES_FROM_ACTIVE_CARD)
    end

  end
end
