require 'rails_helper'

RSpec.describe Topic, type: :model do

  let(:subject) { create(:topic) }

  describe 'associations' do
    it { is_expected.to have_many(:cards) }
    it { is_expected.to have_many(:decks) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(30) }
  end

  describe '#ordered' do
    it 'orders the topics by title ascending' do
      create(:topic, title: 'ABC')
      create(:topic, title: 'ABB')
      create(:topic, title: 'AAA')

      ordered_titles = Topic.ordered.map(&:title)
      expect(ordered_titles).to eq(%w[AAA ABB ABC])
    end
  end

  describe '#decks_count' do
    it 'returns the number of associated decks' do
      create(:deck, topic: subject)
      create(:deck, topic: subject)
      create(:deck, topic: create(:topic))

      expect(subject.decks_count).to eq(2)
    end
  end

  describe '#cards_count' do
    it 'returns the number of associated cards through decks' do
      deck1 = create(:deck, topic: subject)
      deck2 = create(:deck, topic: subject)

      3.times { create(:active_card, deck: deck1) }
      2.times { create(:active_card, deck: deck2) }

      expect(subject.cards_count).to eq(5)
    end

    it 'return 0 if there are no associated decks' do
      expect(subject.decks_count).to eq(0)
      expect(subject.cards_count).to eq(0)
    end
  end

  describe '#pending_cards' do
    it 'returns all pending cards associated to that topic' do
      deck1 = create(:deck, topic: subject)
      deck2 = create(:deck, topic: subject)

      pending_card1 = create(:active_card, :pending, deck: deck1)
      pending_card2 = create(:active_card, :pending, deck: deck2)
      pending_card3 = create(:active_card, :pending, deck: deck2)
      _done_card = create(:active_card, :done, deck: deck1)

      expect(subject.pending_cards).to contain_exactly(pending_card1, pending_card2, pending_card3)
    end

    it 'ignores pending cards of other decks' do
      deck = create(:deck, topic: create(:topic))
      _pending_card = create(:active_card, :pending, deck: deck)

      expect(subject.pending_cards).to be_empty
    end
  end

  describe '#next_recall' do
    it 'returns the minimum next recall date of the associated cards' do
      deck1 = create(:deck, topic: subject)
      deck2 = create(:deck, topic: subject)

      create(:active_card, deck: deck1, next_recall: Time.parse('2020-01-03 10:00'))
      create(:active_card, deck: deck1, next_recall: Time.parse('2020-01-02 10:00'))
      create(:active_card, deck: deck2, next_recall: Time.parse('2020-01-02 10:01'))

      expect(subject.next_recall).to eq Time.parse('2020-01-02 10:00')
    end
  end

  describe '#to_s' do
    it 'returns the topic title' do
      subject = create(:topic, title: 'my topic')
      expect(subject.to_s).to eq('my topic')
    end
  end

end
