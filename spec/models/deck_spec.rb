require 'rails_helper'

RSpec.describe Deck, type: :model do

  describe 'associations' do
    it { is_expected.to belong_to(:topic) }
    it { is_expected.to have_many(:cards) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(30) }
    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:topic_id).case_insensitive }
    it { is_expected.to validate_presence_of(:topic) }
  end

  let(:topic) { Topic.create(title: 'example topic') }
  let(:deck) { Deck.create(title: 'my deck', topic:)}

  describe '#ordered' do
    it 'orders the decks by title ascending' do
      Deck.create(title: 'ABC', topic:)
      Deck.create(title: 'ABB', topic:)
      Deck.create(title: 'AAA', topic:)

      ordered_titles = Deck.ordered.map(&:title)
      expect(ordered_titles).to eq(%w[AAA ABB ABC])
    end
  end

  describe '#cards_count' do
    it 'returns the number of cards associated to the deck' do
      card_1 = ActiveCard.create(deck: deck, question: 'this is a question', answer: 'this is an answer')
      another_card = ActiveCard.create(question: 'this is a question', answer: 'this is an answer', deck: Deck.create(title: 'another_deck', topic: topic))
      card_2 = ActiveCard.create(deck: deck, question: 'this is a question', answer: 'this is an answer')

      expect(deck.cards_count).to eq 2
    end
  end

  describe '#pending_cards' do
    it 'returns only pending cards associated to the deck' do
      pending_card = ActiveCard.create(deck:, question: 'this is a question', answer: 'this is an answer', next_recall: Date.today)
      not_pending = ActiveCard.create(deck:, question: 'this is a question', answer: 'this is an answer', next_recall: Date.tomorrow)
      pending_card_2 = ActiveCard.create(deck:, question: 'this is a question', answer: 'this is an answer', next_recall: Date.yesterday)

      expect(deck.pending_cards).to contain_exactly(pending_card, pending_card_2)
    end
  end

  describe '#next_recall' do
    it 'returns the earliest next recall date for the associated cards' do
      ActiveCard.create(deck:, question: 'this is a question', answer: 'this is an answer', next_recall: DateTime.parse('2012-06-06 05:00'))
      ActiveCard.create(deck:, question: 'this is a question', answer: 'this is an answer', next_recall: DateTime.parse('2012-06-05 06:00'))
      ActiveCard.create(deck:, question: 'this is a question', answer: 'this is an answer', next_recall: DateTime.parse('2012-06-05 06:01'))

      expect(deck.next_recall).to eq DateTime.parse('2012-06-05 06:00')
    end
  end

  describe '#to_s' do
    it 'returns the title of the deck' do
      deck.title = 'my awesome deck'
      expect(deck.to_s).to eq 'my awesome deck'
    end
  end

end
