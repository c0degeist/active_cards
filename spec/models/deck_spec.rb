require 'rails_helper'

RSpec.describe Deck, type: :model do

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(30) }
  end

end
