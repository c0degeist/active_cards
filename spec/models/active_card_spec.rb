require 'rails_helper'

RSpec.describe ActiveCard, type: :model do

  describe 'associations' do
    it { is_expected.to belong_to(:deck) }
  end

end
