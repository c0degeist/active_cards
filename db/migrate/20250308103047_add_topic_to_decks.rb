class AddTopicToDecks < ActiveRecord::Migration[7.2]

  def change
    add_column :decks, :topic_id, :integer
  end

end
