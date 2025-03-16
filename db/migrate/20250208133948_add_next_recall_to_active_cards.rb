class AddNextRecallToActiveCards < ActiveRecord::Migration[7.2]

  def change
    add_column :active_cards, :next_recall, :datetime
  end

end
